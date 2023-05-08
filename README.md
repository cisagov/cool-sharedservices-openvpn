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
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 3.38 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.38 |
| aws.organizationsreadonly | ~> 3.38 |
| aws.provision\_sharedservices | ~> 3.38 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| cw\_alarms\_openvpn | github.com/cisagov/instance-cw-alarms-tf-module | n/a |
| openvpn | github.com/cisagov/openvpn-server-tf-module | improvement%2Fadd-cloud-init-foo-for-crowdstrike |

## Resources ##

| Name | Type |
|------|------|
| [aws_iam_policy.provisionopenvpn_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.provisionopenvpn_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.assessment_environment_services_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_to_assessment_env_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sharedservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.provisionopenvpn_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.cool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.cdm](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.dns_certboto](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.freeipa](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.images_parameterstore](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.public_dns](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region where the shared services account is to be created (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| cert\_bucket\_name | The name of the AWS S3 bucket where certificates are stored. | `string` | `"cisa-cool-certificates"` | no |
| client\_dns\_search\_domain | The DNS search domain to be pushed to VPN clients. | `string` | n/a | yes |
| client\_dns\_server | The address of the DNS server to be pushed to the VPN clients. | `string` | n/a | yes |
| client\_motd\_url | A URL to the motd page.  This will be pushed to VPN clients as an environment variable. | `string` | `"https://github.com/cisagov/cool-system/blob/develop/motd.md#welcome-to-cisas-cloud-oriented-operations-lab-cool"` | no |
| client\_network | A string containing the network and netmask to assign client addresses. The server will take the first address. (e.g. "10.240.0.0 255.255.255.0"). | `string` | n/a | yes |
| cool\_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | `string` | `"cool.cyber.dhs.gov"` | no |
| crowdstrike\_falcon\_sensor\_customer\_id\_key | The SSM Parameter Store key whose corresponding value contains the customer ID for CrowdStrike Falcon (e.g. /cdm/falcon/customer\_id). | `string` | `"/cdm/falcon/customer_id"` | no |
| private\_networks | A list of strings, each of which contains a network and netmask defining a list of subnets that exist behind the VPN server (e.g. ["10.224.0.0 255.240.0.0", "192.168.100.0 255.255.255.0"]).  This will be concatenated with the list of S3 gateway endpoint routes and the result will be pushed to the clients. | `list(string)` | n/a | yes |
| provisionaccount\_role\_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `"ProvisionAccount"` | no |
| provisionopenvpn\_policy\_description | The description to associate with the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | `string` | `"Allows provisioning of OpenVPN in the Shared Services account."` | no |
| provisionopenvpn\_policy\_name | The name to assign the IAM policy that allows provisioning of OpenVPN in the Shared Services account. | `string` | `"ProvisionOpenVPN"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| trusted\_cidr\_blocks\_vpn | A list of the CIDR blocks that are allowed to access the VPN port on the VPN servers (e.g. ["10.10.0.0/16", "10.11.0.0/16"]). | `list(string)` | `[]` | no |

## Outputs ##

| Name | Description |
|------|-------------|
| assessment\_environment\_services\_access\_security\_group | The security group allowing VPN users access to services running in the assessment environments. |
| instance\_id | The ID corresponding to the OpenVPN server EC2 instance. |
| security\_group\_id | The ID corresponding to the OpenVPN server security group. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, that is only the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
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
