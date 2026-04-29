# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # Find the "Images" account ID by name.
  images_account_id = [
    for account in data.aws_organizations_organization.cool.non_master_accounts :
    account.id if account.name == "Images"
  ][0]

  # Turn the prefix list CIDRS for the S3 gateway endpoint into a list of OpenVPN
  # friendly "network netmask" entries.
  vpc_endpoints = [
    for cidr in data.terraform_remote_state.networking.outputs.vpc_endpoint_s3.cidr_blocks :
    format("%s %s", split("/", cidr)[0], cidrnetmask(cidr))
  ]

  # Ports to be accessed in assessment environments (e.g. for
  # Advanced Ops VPN endpoints, Guacamole, Mattermost, etc.)
  assessment_env_service_ports = {
    ao_vpn_endpoints_tcp = {
      from_port = 60000
      protocol  = "tcp"
      to_port   = 60100
    },
    ao_vpn_endpoints_udp_1 = {
      from_port = 51820
      protocol  = "udp"
      to_port   = 51835
    },
    ao_vpn_endpoints_udp_2 = {
      from_port = 60000
      protocol  = "udp"
      to_port   = 60100
    },
    http = {
      from_port = 80
      protocol  = "tcp"
      to_port   = 80
    },
    https = {
      from_port = 443
      protocol  = "tcp"
      to_port   = 443
    },
    mm_unknown0 = {
      from_port = 3478
      protocol  = "udp"
      to_port   = 3478
    },
    mm_unknown1 = {
      from_port = 5349
      protocol  = "tcp"
      to_port   = 5349
    },
    mm_web = {
      from_port = 8065
      protocol  = "tcp"
      to_port   = 8065
    },
    mm_unknown2 = {
      from_port = 10000
      protocol  = "udp"
      to_port   = 10000
    },
  }

  base_vpn_security_group_ids = [
    aws_security_group.assessment_environment_services_access.id,
    data.terraform_remote_state.freeipa.outputs.client_security_group.id,
    data.terraform_remote_state.networking.outputs.cloudwatch_agent_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.s3_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.ssm_agent_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.ssm_endpoint_client_security_group.id,
    data.terraform_remote_state.networking.outputs.sts_endpoint_client_security_group.id,
  ]

  # Conditionally include the CDM security group, which is only used in Production
  vpn_security_group_ids = terraform.workspace == "production" ? concat(local.base_vpn_security_group_ids, [data.terraform_remote_state.cdm.outputs.cdm_security_group.id]) : local.base_vpn_security_group_ids
}
