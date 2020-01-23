# cool-shared-services-openvpn #

[![GitHub Build Status](https://github.com/cisagov/cool-shared-services-openvpn/workflows/build/badge.svg)](https://github.com/cisagov/cool-shared-services-openvpn/actions)

This is a Terraform module for creating an OpenVPN server in the COOL
shared services environment.  This deployment should be laid down on
top of
[cisagov/cool-shared-services-networking](https://github.com/cisagov/cool-shared-services-networking),
after
[cisagov/cool-shared-services-freeipa](https://github.com/cisagov/cool-shared-services-freeipa)
has been applied

## Usage ##

```hcl
module "example" {
  source = "github.com/cisagov/cool-shared-services-openvpn"

  aws_region                       = "us-east-1"
  cert_bucket_name                 = "certbucket"
  cert_create_read_role_arn        = "arn:aws:iam::123456789012:role/CertCreateReadRole"
  cool_domain                      = "example.com"
  default_role_arn                 = "arn:aws:iam::123456789012:role/TerraformRole"
  dns_role_arn                     = "arn:aws:iam::123456789012:role/DnsRole"
  freeipa_admin_pw                 = "thepassword"
  freeipa_client_security_group_id = "sg-0123456789abcdef0"
  private_reverse_zone_id          = "ZLY47KYR9X93M"
  private_zone_id                  = "ZKX36JXQ8W82L"
  public_zone_name                 = "ipa.example.gov"
  ssm_create_read_role_arn         = "arn:aws:iam::123456789012:role/SsmCreateReadRole"
  subnet_id                        = "subnet-0123456789abcdef0"
  tags                             = {
    Key1 = "Value1"
    Key2 = "Value2"
  }
  trusted_cidr_blocks              = [
    "10.99.49.0/24",
    "10.99.52.0/24"
  ]
}
```

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1). | string | | yes |
| cert_bucket_name | The name of the AWS S3 bucket where certificates are stored. | string | `cool-certificates` | no |
| cert_create_read_role_arn | The ARN of the role to assume when creating a role to allow reading certboto certificate data (e.g. "arn:aws:iam::123456789012:role/CertCreateReadRole"). | string | | yes |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | string | `cool.cyber.dhs.gov` | no |
| default_role_arn | The ARN of the role to assume when performing most Terraform tasks (e.g. "arn:aws:iam::123456789012:role/TerraformRole"). | string | | yes |
| dns_role_arn | The ARN of the role to assume when performing public DNS Terraform tasks (e.g. "arn:aws:iam::123456789012:role/DnsRole"). | string | | yes |
| freeipa_admin_pw | The password for the FreeIPA Kerberos admin role. | string | | yes |
| freeipa_client_security_group_id | The ID of the security group for FreeIPA clients. | string | | yes |
| private_reverse_zone_id | The zone ID corresponding to the private Route53 reverse zone (e.g. "Z01234567YYYYY89FFF0T"). | string | | yes |
| private_zone_id | The zone ID corresponding to the private Route53 zone for the COOL shared services VPC (e.g. "Z01234567YYYYY89FFF0T"). | string | | yes |
| public_zone_name | The name of the public Route53 zone where public DNS records should be created (e.g. "cyber.dhs.gov."). | string | `cyber.dhs.gov` | no |
| subnet_id | The ID of the subnet where the OpenVPN server is to be deployed (e.g. "subnet-0123456789abcdef0"). | string | | yes |
| ssm_create_read_role_arn | The ARN of the role to assume when creating a role to allow reading of SSM parameters (e.g. "arn:aws:iam::123456789012:role/SsmCreateReadRole") | string | | yes |
| tags | Tags to apply to all AWS resources created. | map(string) | `{}` | no |
| trusted_cidr_blocks | A list of the CIDR blocks outside the VPC that are allowed to access the OpenVPN server (e.g. ["10.10.0.0/16", "10.11.0.0/16"]). | list(string) | `[]` | no |

## Outputs ##

| Name | Description |
|------|-------------|
| instance_id | The ID corresponding to the OpenVPN server EC2 instance. |
| security_group_id | The ID corresponding to the OpenVPN server security group. |

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
