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
