#-------------------------------------------------------------------------------
# Configure the OpenVPN server module.
#-------------------------------------------------------------------------------

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
  source = "github.com/cisagov/openvpn-server-tf-module?ref=improvement%2Fadd-input-var-for-disk-size"

  providers = {
    aws                = aws.provision_sharedservices
    aws.dns            = aws.public_dns
    aws.cert_read_role = aws.provision_certificate_read_role
    aws.ssm_read_role  = aws.provision_ssm_parameter_read_role
  }

  ami_owner_account_id = local.images_account_id
  aws_instance_type    = "t3.medium"
  cert_bucket_name     = var.cert_bucket_name
  cert_read_role_accounts_allowed = [
    data.aws_caller_identity.sharedservices.account_id
  ]
  client_dns_search_domain                  = var.client_dns_search_domain
  client_dns_server                         = var.client_dns_server
  client_motd_url                           = var.client_motd_url
  client_network                            = var.client_network
  crowdstrike_falcon_sensor_customer_id_key = var.crowdstrike_falcon_sensor_customer_id_key
  crowdstrike_falcon_sensor_tags_key        = var.crowdstrike_falcon_sensor_tags_key
  freeipa_domain                            = var.cool_domain
  freeipa_realm                             = upper(var.cool_domain)
  hostname                                  = "vpn.${var.cool_domain}"
  nessus_hostname_key                       = var.nessus_hostname_key
  nessus_key_key                            = var.nessus_key_key
  nessus_port_key                           = var.nessus_port_key
  private_networks                          = concat(local.vpc_endpoints, var.private_networks)
  private_reverse_zone_id                   = data.terraform_remote_state.networking.outputs.public_subnet_private_reverse_zones[local.openvpn_subnet_cidr].id
  private_zone_id                           = data.terraform_remote_state.networking.outputs.private_zone.id
  public_zone_id                            = data.terraform_remote_state.public_dns.outputs.cyber_dhs_gov_zone.id
  root_disk_size                            = var.root_disk_size
  security_groups = [
    aws_security_group.assessment_environment_services_access.id,
    data.terraform_remote_state.cdm.outputs.cdm_security_group.id,
    data.terraform_remote_state.freeipa.outputs.client_security_group.id,
    data.terraform_remote_state.networking.outputs.cloudwatch_agent_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.s3_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.ssm_agent_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.ssm_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.sts_endpoint_client_security_group.id,
  ]
  ssm_read_role_accounts_allowed = [
    data.aws_caller_identity.sharedservices.account_id
  ]
  subnet_id               = data.terraform_remote_state.networking.outputs.public_subnets[local.openvpn_subnet_cidr].id
  trusted_cidr_blocks_vpn = var.trusted_cidr_blocks_vpn
  vpn_group               = "vpnusers"
}

# CloudWatch alarms for the OpenVPN instance
module "cw_alarms_openvpn" {
  providers = {
    aws = aws.provision_sharedservices
  }
  source = "github.com/cisagov/instance-cw-alarms-tf-module"

  alarm_actions = [data.terraform_remote_state.sharedservices.outputs.cw_alarm_sns_topic.arn]
  instance_ids = [
    module.openvpn.id,
  ]
  insufficient_data_actions = [data.terraform_remote_state.sharedservices.outputs.cw_alarm_sns_topic.arn]
  ok_actions                = [data.terraform_remote_state.sharedservices.outputs.cw_alarm_sns_topic.arn]
}
