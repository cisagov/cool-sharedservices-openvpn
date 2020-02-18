# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "client_network" {
  description = "A string containing the network and netmask to assign client addresses. The server will take the first address. (e.g. \"10.240.0.0 255.255.255.0\")."
}

variable "freeipa_admin_pw" {
  description = "The password for the Kerberos admin role."
}

variable "freeipa_client_security_group_id" {
  description = "The ID of the FreeIPA client security group (e.g. \"sg-0123456789abcdef0\")."
}

variable "private_networks" {
  type        = list(string)
  description = "A list of strings, each of which contains a network and netmask defining a list of subnets that exist behind the VPN server (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"]).  These will be pushed to the clients."
}

variable "private_reverse_zone_id" {
  description = "The zone ID corresponding to the private Route53 reverse zone appropriate for the IPA master (e.g. \"Z01234567YYYYY89FFF0T\")."
}

variable "private_zone_id" {
  description = "The zone ID corresponding to the private Route53 zone for the COOL shared services VPC (e.g. \"Z01234567YYYYY89FFF0T\")."
}

variable "subnet_id" {
  description = "The ID of the subnet where the IPA master is to be deployed (e.g. \"subnet-0123456789abcdef0\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "cert_bucket_name" {
  description = "The name of the AWS S3 bucket where certificates are stored."
  default     = "cool-certificates"
}

variable "cool_domain" {
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
  default     = "cool.cyber.dhs.gov"
}

variable "public_zone_name" {
  description = "The name of the public Route53 zone where public DNS records should be created (e.g. \"cyber.dhs.gov.\")."
  default     = "cyber.dhs.gov."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}

variable "trusted_cidr_blocks" {
  type        = list(string)
  description = "A list of the CIDR blocks outside the VPC that are allowed to access the IPA servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])."
  default     = []
}
