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
  # Guacamole, Mattermost, etc.)
  assessment_env_service_ports = {
    http = {
      port     = 80
      protocol = "tcp"
    },
    https = {
      port     = 443
      protocol = "tcp"
    },
    mm_unknown0 = {
      port     = 3478
      protocol = "udp"
    },
    mm_unknown1 = {
      port     = 5379
      protocol = "tcp"
    },
    mm_web = {
      port     = 8065
      protocol = "tcp"
    },
    mm_unknown2 = {
      port     = 10000
      protocol = "udp"
    },
  }
}
