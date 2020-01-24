cert_create_read_role_arn = "arn:aws:iam::351049339218:role/CreateCertificateReadRoles"
default_role_arn          = "arn:aws:iam::519052064992:role/CreateOpenVPN"
dns_role_arn              = "arn:aws:iam::344440683180:role/ModifyPublicDNS"
ssm_create_read_role_arn  = "arn:aws:iam::608004238745:role/CreateSSMReadRoles"

client_network   = ""
private_networks = []

freeipa_admin_pw = "lemmy"
# freeipa_client_security_group_id = "sg-0f81fadc298c4894b"
private_reverse_zone_id = "Z06280281IUID9IIQ52DI"
private_zone_id         = "Z06280926BVM3E95049U"
subnet_id               = "subnet-01547487ccf127849"

aws_region = "us-east-1"
# cert_bucket_name   = "cool-certificates"
cool_domain = "jsf9k.cyber.dhs.gov"
# public_zone_name   = "cyber.dhs.gov"
tags = {
  Team        = "NCATS OIS - Development"
  Application = "COOL Migration - OpenVPN"
  Workspace   = "jsf9k"
  Testing     = true
}
# 64.69.57.0/24         CAL
# 96.255.220.144/32     DaveR
# 71.178.13.219/32      Kyle
# 173.66.73.61/32       Mark
# 73.12.105.239/32      Nick
# 108.31.3.53/32        Shane
trusted_cidr_blocks = [
  "64.69.57.0/24",
  #  "96.255.220.144/32",
  #  "71.178.13.219/32",
  #  "173.66.73.61/32",
  #  "73.12.105.239/32",
  "108.31.3.53/32"
]
