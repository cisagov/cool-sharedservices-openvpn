output "instance_id" {
  value       = module.openvpn.id
  description = "The ID corresponding to the OpenVPN server EC2 instance."
}

output "security_group_id" {
  value       = module.openvpn.security_group_id
  description = "The ID corresponding to the OpenVPN server security group."
}
