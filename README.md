# cool-sharedservices-openvpn #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-openvpn/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-openvpn/actions)

This is a Terraform module for creating an OpenVPN server in the COOL
Shared Services account.  This deployment should be laid down on top
of
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking),
after
[cisagov/cool-sharedservices-freeipa](https://github.com/cisagov/cool-sharedservices-freeipa)
has been applied

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1). | string | | yes |
| cert_bucket_name | The name of the AWS S3 bucket where certificates are stored. | string | `cisa-cool-certificates` | no |
| cert_create_read_role_arn | The ARN of the role to assume when creating a role to allow reading certboto certificate data (e.g. "arn:aws:iam::123456789012:role/CertCreateReadRole"). | string | | yes |
| client_network | A string containing the network and netmask to assign client addresses. The server will take the first address. (e.g. "10.240.0.0 255.255.255.0"). | string | | yes |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | string | `cool.cyber.dhs.gov` | no |
| default_role_arn | The ARN of the role to assume when performing most Terraform tasks (e.g. "arn:aws:iam::123456789012:role/TerraformRole"). | string | | yes |
| dns_role_arn | The ARN of the role to assume when performing public DNS Terraform tasks (e.g. "arn:aws:iam::123456789012:role/DnsRole"). | string | | yes |
| freeipa_admin_pw | The password for the FreeIPA Kerberos admin role. | string | | yes |
| freeipa_client_security_group_id | The ID of the security group for FreeIPA clients. | string | | yes |
| private_networks | A list of strings, each of which contains a network and netmask defining a list of subnets that exist behind the VPN server (e.g. ["10.224.0.0 255.240.0.0", "192.168.100.0 255.255.255.0"]).  These will be pushed to the clients. | list(string) | | yes |
| private_reverse_zone_id | The zone ID corresponding to the private Route53 reverse zone (e.g. "Z01234567YYYYY89FFF0T"). | string | | yes |
| private_zone_id | The zone ID corresponding to the private Route53 zone for the COOL shared services VPC (e.g. "Z01234567YYYYY89FFF0T"). | string | | yes |
| provisionaccount_role_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | string | `ProvisionAccount` | no |
| provisionopenvpn_policy_description | The description to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | string | `Allows provisioning of OpenVPN in the Shared Services account.` | no |
| provisionopenvpn_policy_name | The name to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | string | `ProvisionOpenvpn` | no |
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
