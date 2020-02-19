#-------------------------------------------------------------------------------
# Configure the OpenVPN server module.
#-------------------------------------------------------------------------------
locals {
  # We can extract this from the variable default_role_arn
  shared_services_account_id = split(":", var.default_role_arn)[4]
}

module "openvpn" {
  source = "github.com/cisagov/openvpn-server-tf-module"

  providers = {
    aws                = aws
    aws.dns            = aws.public_dns
    aws.cert_read_role = aws.provision_cert_read_role
    aws.ssm_read_role  = aws.provision_ssm_read_role
  }

  # aws_instance_type               = "t3.small"
  cert_bucket_name = var.cert_bucket_name
  cert_read_role_accounts_allowed = [
    local.shared_services_account_id
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
    local.shared_services_account_id
  ]
  subdomain           = "trimsuffix(var.cool_domain, .${var.public_zone_name})"
  subnet_id           = var.subnet_id
  tags                = var.tags
  trusted_cidr_blocks = var.trusted_cidr_blocks
}
