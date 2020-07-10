# cool-sharedservices-openvpn #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-openvpn/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-openvpn/actions)

This is a Terraform module for creating an OpenVPN server in the COOL
Shared Services account.  This deployment should be laid down on top
of
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking),
after
[cisagov/cool-sharedservices-freeipa](https://github.com/cisagov/cool-sharedservices-freeipa)
has been applied.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified [here](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified [here](backend.tf)).
- Access to all of the Terraform remote states specified in
  [the remote states file](remote_states.tf).

## Requirements ##

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers ##

| Name | Version |
|------|---------|
| aws | n/a |
| aws.organizationsreadonly | n/a |
| aws.public_dns | n/a |
| aws.provision_certificate_read_role | n/a |
| aws.provision_sharedservices | n/a |
| aws.provision_ssm_parameter_read_role | n/a |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws_region | The AWS region where the shared services account is to be created (e.g. "us-east-1"). | `string` | `us-east-1` | no |
| cert_bucket_name | The name of the AWS S3 bucket where certificates are stored. | `string` | `cisa-cool-certificates` | no |
| client_dns_search_domain | The DNS search domain to be pushed to VPN clients. | `string` | n/a | yes |
| client_dns_server | The address of the DNS server to be pushed to the VPN clients. | `string` | n/a | yes |
| client_motd_url | A URL to the motd page.  This will be pushed to VPN clients as an environment variable. | `string` | `https://github.com/cisagov/cool-system/blob/develop/motd.md#welcome-to-cisas-cloud-oriented-operations-lab-cool` | no |
| client_network | A string containing the network and netmask to assign client addresses. The server will take the first address. (e.g. "10.240.0.0 255.255.255.0"). | `string` | n/a | yes |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | `string` | `cool.cyber.dhs.gov` | no |
| freeipa_admin_pw | The password for the Kerberos admin role. | `string` | n/a | yes |
| private_networks | A list of strings, each of which contains a network and netmask defining a list of subnets that exist behind the VPN server (e.g. ["10.224.0.0 255.240.0.0", "192.168.100.0 255.255.255.0"]).  These will be pushed to the clients. | `list(string)` | n/a | yes |
| provisionaccount_role_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `ProvisionAccount` | no |
| provisionopenvpn_policy_description | The description to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | `string` | `Allows provisioning of OpenVPN in the Shared Services account.` | no |
| provisionopenvpn_policy_name | The name to assign the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | `string` | `ProvisionOpenVPN` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| trusted_cidr_blocks_vpn | A list of the CIDR blocks that are allowed to access the VPN port on the VPN servers (e.g. ["10.10.0.0/16", "10.11.0.0/16"]). | `list(string)` | `[]` | no |

## Outputs ##

| Name | Description |
|------|-------------|
| instance_id | The ID corresponding to the OpenVPN server EC2 instance. |
| security_group_id | The ID corresponding to the OpenVPN server security group. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, that is only the main directory.

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
