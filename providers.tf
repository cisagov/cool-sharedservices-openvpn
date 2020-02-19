provider "aws" {
  profile = "cool-sharedservices-provisionaccount"
  region  = var.aws_region
}

provider "aws" {
  alias   = "public_dns"
  profile = "cool-olddns-route53fullaccess"
  region  = var.aws_region
}

provider "aws" {
  alias   = "provision_cert_read_role"
  profile = "cool-dns-provisioncertificatereadroles"
  region  = var.aws_region
}

provider "aws" {
  alias   = "provision_ssm_read_role"
  profile = "cool-images-provisionparameterstorereadroles"
  region  = var.aws_region
}
