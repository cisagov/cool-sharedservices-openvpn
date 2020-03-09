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
  default     = "cisa-cool-certificates"
}

variable "cool_domain" {
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
  default     = "cool.cyber.dhs.gov"
}

variable "provisionaccount_role_name" {
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisionopenvpn_policy_description" {
  description = "The description to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account."
  default     = "Allows provisioning of OpenVPN in the Shared Services account."
}

variable "provisionopenvpn_policy_name" {
  description = "The name to assign the IAM policy that allows provisioning of OpenVPN in the Shared Services account."
  default     = "ProvisionOpenVPN"
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
