# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # The Shared Services account ID
  sharedservices_account_id = data.aws_caller_identity.sharedservices.account_id

  # Look up Shared Services account name from AWS organizations
  # provider
  sharedservices_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.sharedservices_account_id
  ][0]

  # Determine Shared Services account type based on account name.
  #
  # The account name format is "ACCOUNT_NAME (ACCOUNT_TYPE)" - for
  # example, "Shared Services (Production)".
  sharedservices_account_type = length(regexall("\\(([^()]*)\\)", local.sharedservices_account_name)) == 1 ? regex("\\(([^()]*)\\)", local.sharedservices_account_name)[0] : "Unknown"

  # Determine the ID of the corresponding Images account
  images_account_id = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.id
    if account.name == "Images (${local.sharedservices_account_type})"
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
    ao_vpn_endpoints = {
      from_port = 51820
      protocol  = "udp"
      to_port   = 51835
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
}
