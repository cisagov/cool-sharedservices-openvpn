#-------------------------------------------------------------------------------
# Configure the OpenVPN server module.
#-------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# We can get the account ID of the Shared Services account from the
# default provider's caller identity.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "default" {
}

locals {
  # OpenVPN currently only uses a single public subnet, so grab the
  # CIDR of the one with the smallest third octet.
  #
  # It's tempting to just use keys()[0] here, but the keys are sorted
  # lexicographically.  That means that "10.1.10.0/24" would come
  # before "10.1.9.0/24".
  public_subnet_cidrs = keys(data.terraform_remote_state.networking.outputs.public_subnets)
  first_octet         = split(".", local.public_subnet_cidrs[0])[0]
  second_octet        = split(".", local.public_subnet_cidrs[0])[1]
  third_octets        = [for cidr in local.public_subnet_cidrs : split(".", cidr)[2]]
  # This flatten([]) shouldn't be necessary, but it is.  I think this
  # is related to hashicorp/terraform#22404.
  third_octet         = min(flatten([local.third_octets])...)
  openvpn_subnet_cidr = format("%d.%d.%d.0/24", local.first_octet, local.second_octet, local.third_octet)
}

module "openvpn" {
  source = "github.com/cisagov/openvpn-server-tf-module?ref=improvement%2Fseparate-trusted-ip-lists-for-ssh-and-vpn"

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
  client_dns_search_domain = var.client_dns_search_domain
  client_dns_server        = var.client_dns_server
  client_network           = var.client_network
  domain                   = var.public_zone_name
  freeipa_admin_pw         = var.freeipa_admin_pw
  freeipa_realm            = upper(var.cool_domain)
  hostname                 = "vpn.${var.cool_domain}"
  private_networks         = var.private_networks
  private_reverse_zone_id  = data.terraform_remote_state.networking.outputs.public_subnet_private_reverse_zones[local.openvpn_subnet_cidr].id
  private_zone_id          = data.terraform_remote_state.networking.outputs.private_zone.id
  security_groups = [
    data.terraform_remote_state.freeipa.outputs.client_security_group.id
  ]
  ssm_read_role_accounts_allowed = [
    data.aws_caller_identity.default.account_id
  ]
  subnet_id               = data.terraform_remote_state.networking.outputs.public_subnets[local.openvpn_subnet_cidr].id
  tags                    = var.tags
  trusted_cidr_blocks_ssh = var.trusted_cidr_blocks_ssh
  trusted_cidr_blocks_vpn = var.trusted_cidr_blocks_vpn
}
