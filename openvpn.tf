#-------------------------------------------------------------------------------
# Configure the OpenVPN server module.
#-------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# We can get the account ID of the Shared Services account from the
# default provider's caller identity.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "default" {
}

module "openvpn" {
  source = "github.com/cisagov/openvpn-server-tf-module"

  providers = {
    aws                = aws
    aws.dns            = aws.public_dns
    aws.cert_read_role = aws.provision_certificate_read_role
    aws.ssm_read_role  = aws.provision_ssm_parameter_read_role
  }

  ami_owner_account_id = "207871073513" # The COOL Images account
  # aws_instance_type       = "t3.small"
  cert_bucket_name = var.cert_bucket_name
  cert_read_role_accounts_allowed = [
    data.aws_caller_identity.default.account_id
  ]
  client_network          = var.client_network
  domain                  = var.public_zone_name
  freeipa_admin_pw        = var.freeipa_admin_pw
  freeipa_realm           = upper(var.cool_domain)
  hostname                = "vpn.${var.cool_domain}"
  private_networks        = [data.terraform_remote_state.networking.outputs.vpc.cidr_block]
  private_reverse_zone_id = data.terraform_remote_state.networking.outputs.public_subnet_private_reverse_zones["10.128.9.0/24"].id
  private_zone_id         = data.terraform_remote_state.networking.outputs.private_zone.id
  security_groups = [
    data.terraform_remote_state.freeipa.outputs.client_security_group.id
  ]
  ssm_read_role_accounts_allowed = [
    data.aws_caller_identity.default.account_id
  ]
  subnet_id           = data.terraform_remote_state.networking.outputs.public_subnets["10.128.9.0/24"].id
  tags                = var.tags
  trusted_cidr_blocks = var.trusted_cidr_blocks
}
