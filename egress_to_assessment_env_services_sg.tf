# Security group for assessment environment access
resource "aws_security_group" "assessment_environment_services_access" {
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc.id
  description = "Security group allowing access to assessment environment services."
}

# Access to assessment environment services (e.g., guacamole,
# Mattermost, etc.)
resource "aws_security_group_rule" "egress_to_assessment_env_services" {
  for_each = local.assessment_env_service_ports

  security_group_id = aws_security_group.assessment_environment_services_access.id
  type              = "egress"
  protocol          = each.value["protocol"]
  cidr_blocks       = [data.terraform_remote_state.networking.outputs.cool_cidr_block]
  from_port         = each.value["port"]
  to_port           = each.value["port"]
}
