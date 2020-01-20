output "ipa_client_security_group_id" {
  value       = module.ipa_master.client_security_group_id
  description = "The ID corresponding to the IPA client security group."
}

output "ipa_master_cert_read_role_arn" {
  value       = module.certreadrole_ipa_master.arn
  description = "The ARN corresponding to the role used by the IPA master to read its certificate information."
}

output "ipa_master_id" {
  value       = module.ipa_master.id
  description = "The EC2 instance ID corresponding to the IPA master."
}

output "ipa_replica1_cert_read_role_arn" {
  value       = module.certreadrole_ipa_replica1.arn
  description = "The ARN corresponding to the role used by the first IPA replica to read its certificate information."
}

output "ipa_replica1_id" {
  value       = module.ipa_replica1.id
  description = "The EC2 instance ID corresponding to the first IPA replica."
}

output "ipa_replica2_cert_read_role_arn" {
  value       = module.certreadrole_ipa_replica2.arn
  description = "The ARN corresponding to the role used by the second IPA replica to read its certificate information."
}

output "ipa_replica2_id" {
  value       = module.ipa_replica2.id
  description = "The EC2 instance ID corresponding to the second IPA replica."
}

output "ipa_server_security_group_id" {
  value       = module.ipa_master.server_security_group_id
  description = "The ID corresponding to the IPA server security group."
}

output "private_subnet_ids" {
  value       = module.private_subnets.subnet_ids
  description = "The subnets IDs corresponding to the private subnets in the VPC."
}

output "private_subnet_nat_gw_ids" {
  value       = zipmap(module.private_subnets.subnet_ids, aws_nat_gateway.nat_gws[*].id)
  description = "The IDs corresponding to the NAT gateways used in the private subnets in the VPC."
}

output "private_zone_id" {
  value       = aws_route53_zone.private_zone.zone_id
  description = "The zone ID corresponding to the private Route53 zone for the VPC."
}

output "private_subnet_private_reverse_zone_ids" {
  value       = zipmap(module.private_subnets.subnet_ids, aws_route53_zone.private_subnet_private_reverse_zones[*].zone_id)
  description = "The zone IDs corresponding to the private Route53 reverse zones for the private subnets in the VPC."
}

output "public_subnet_ids" {
  value       = module.public_subnets.subnet_ids
  description = "The subnets IDs corresponding to the public subnets in the VPC."
}

output "public_subnet_private_reverse_zone_ids" {
  value       = zipmap(module.public_subnets.subnet_ids, aws_route53_zone.public_subnet_private_reverse_zones[*].zone_id)
  description = "The zone IDs corresponding to the private Route53 reverse zones for the public subnets in the VPC."
}

output "vpc_id" {
  value       = aws_vpc.the_vpc.id
  description = "The ID corresponding to the shared services VPC."
}
