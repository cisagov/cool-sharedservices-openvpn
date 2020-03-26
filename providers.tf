provider "aws" {
  profile = "cool-sharedservices-provisionaccount"
  region  = var.aws_region
}

provider "aws" {
  alias   = "public_dns"
  profile = "cool-dns-route53resourcechange-cyber.dhs.gov"
  region  = var.aws_region
}

provider "aws" {
  alias   = "provision_certificate_read_role"
  profile = "cool-dns-provisioncertificatereadroles"
  region  = var.aws_region
}

provider "aws" {
  alias   = "provision_ssm_parameter_read_role"
  profile = "cool-images-provisionparameterstorereadroles"
  region  = var.aws_region
}

provider "aws" {
  alias   = "organizationsreadonly"
  profile = "cool-master-organizationsreadonly"
  region  = var.aws_region
}
