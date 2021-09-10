output "assessment_environment_services_access_security_group" {
  value       = aws_security_group.assessment_environment_services_access
  description = "The security group allowing VPN users access to services running in the assessment environments."
}

output "instance_id" {
  value       = module.openvpn.id
  description = "The ID corresponding to the OpenVPN server EC2 instance."
}

output "security_group_id" {
  value       = module.openvpn.security_group_id
  description = "The ID corresponding to the OpenVPN server security group."
}
