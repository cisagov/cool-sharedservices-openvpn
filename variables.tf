# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------
variable "client_dns_search_domain" {
  type        = string
  description = "The DNS search domain to be pushed to VPN clients."
}

variable "client_dns_server" {
  type        = string
  description = "The address of the DNS server to be pushed to the VPN clients."
}

variable "client_network" {
  type        = string
  description = "A string containing the network and netmask to assign client addresses. The server will take the first address. (e.g. \"10.240.0.0 255.255.255.0\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "cert_bucket_name" {
  type        = string
  description = "The name of the AWS S3 bucket where certificates are stored."
  default     = "cisa-cool-certificates"
}

variable "client_motd_url" {
  type        = string
  description = "A URL to the motd page.  This will be pushed to VPN clients as an environment variable."
  default     = "https://github.com/cisagov/cool-system/blob/develop/motd.md#welcome-to-cisas-cloud-oriented-operations-lab-cool"
}

variable "cool_domain" {
  type        = string
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
  default     = "cool.cyber.dhs.gov"
}

variable "crowdstrike_falcon_sensor_customer_id_key" {
  type        = string
  description = "The SSM Parameter Store key whose corresponding value contains the customer ID for CrowdStrike Falcon (e.g. /cdm/falcon/customer_id)."
  default     = "/cdm/falcon/customer_id"
}

variable "private_networks" {
  type        = list(string)
  description = "A list of strings, each of which contains a network and netmask defining a list of subnets that exist behind the VPN server (e.g. [\"10.224.0.0 255.240.0.0\", \"192.168.100.0 255.255.255.0\"]).  This will be concatenated with the list of S3 gateway endpoint routes and the result will be pushed to the clients."
}

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisionopenvpn_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account."
  default     = "Allows provisioning of OpenVPN in the Shared Services account."
}

variable "provisionopenvpn_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of OpenVPN in the Shared Services account."
  default     = "ProvisionOpenVPN"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}

variable "trusted_cidr_blocks_vpn" {
  type        = list(string)
  description = "A list of the CIDR blocks that are allowed to access the VPN port on the VPN servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])."
  default     = []
}
