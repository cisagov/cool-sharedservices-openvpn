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

  # aws_instance_type               = "t3.small"
  cert_bucket_name = var.cert_bucket_name
  cert_read_role_accounts_allowed = [
    data.aws_caller_identity.default.account_id
  ]
  client_network          = var.client_network
  domain                  = var.public_zone_name
  freeipa_admin_pw        = var.freeipa_admin_pw
  freeipa_realm           = upper(var.cool_domain)
  hostname                = "vpn"
  private_networks        = var.private_networks
  private_reverse_zone_id = var.private_reverse_zone_id
  private_zone_id         = var.private_zone_id
  security_groups = [
    var.freeipa_client_security_group_id
  ]
  ssm_read_role_accounts_allowed = [
    data.aws_caller_identity.default.account_id
  ]
  subdomain           = "trimsuffix(var.cool_domain, .${var.public_zone_name})"
  subnet_id           = var.subnet_id
  tags                = var.tags
  trusted_cidr_blocks = var.trusted_cidr_blocks
}
