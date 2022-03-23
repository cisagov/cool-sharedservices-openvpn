#-------------------------------------------------------------------------------
# Configure Global Accelerator for the OpenVPN server IP.
#-------------------------------------------------------------------------------

resource "aws_globalaccelerator_accelerator" "openvpn" {
  provider = aws.provision_sharedservices

  name = "COOL-OpenVPN"
}

resource "aws_globalaccelerator_listener" "openvpn" {
  provider = aws.provision_sharedservices

  accelerator_arn = aws_globalaccelerator_accelerator.openvpn.id
  protocol        = "UDP"

  port_range {
    from_port = 1194
    to_port   = 1194
  }
}

# We need this to get the allocation ID of the OpenVPN server's EIP.
data "aws_eip" "openvpn" {
  provider = aws.provision_sharedservices

  public_ip = module.openvpn.public_ip
}

resource "aws_globalaccelerator_endpoint_group" "openvpn" {
  provider = aws.provision_sharedservices

  endpoint_configuration {
    # endpoint_group_region = var.aws_region
    endpoint_id = data.aws_eip.openvpn.id
    # health_check_protocol = "UDP"
    weight = 100
  }
  listener_arn = aws_globalaccelerator_listener.openvpn.id
}
