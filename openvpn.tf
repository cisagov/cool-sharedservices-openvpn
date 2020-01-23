#-------------------------------------------------------------------------------
# Configure the OpenVPN server module.
#-------------------------------------------------------------------------------
module "openvpn" {
  source = "github.com/cisagov/openvpn-server-tf-module"

  providers = {
    aws                = aws
    aws.dns            = aws.public_dns
    aws.cert_read_role = aws.cert_create_read_role
    aws.ssm_read_role  = aws.ssm_create_read_role
  }

  # aws_instance_type               = "t3.small"
  cert_bucket_name = var.cert_bucket_name
  # cert_read_role_accounts_allowed = []
  client_network = ""
  # domain                          = var.cool_domain
  domain                  = "cyber.dhs.gov"
  freeipa_admin_pw        = var.freeipa_admin_pw
  freeipa_realm           = upper(var.cool_domain)
  hostname                = "vpn"
  private_networks        = []
  private_reverse_zone_id = var.private_reverse_zone_id
  private_zone_id         = var.private_zone_id
  security_groups = [
    var.freeipa_client_security_group_id
  ]
  # ssm_read_role_accounts_allowed  = []
  # This should be split off from var.cool_domain?
  subdomain           = "jsf9k"
  subnet_id           = var.subnet_id
  tags                = var.tags
  trusted_cidr_blocks = var.trusted_cidr_blocks
}
