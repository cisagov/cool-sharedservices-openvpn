# ------------------------------------------------------------------------------
# Add a route to send all client traffic to the OpenVPN server.  This
# is required for every route table in use in the VPC.
# ------------------------------------------------------------------------------

# Add a route to the default route table (used by public subnets).
resource "aws_route" "public_vpn_route" {
  route_table_id         = data.terraform_remote_state.networking.outputs.default_route_table.id
  destination_cidr_block = var.client_network
  instance_id            = module.openvpn.id
}

# Add a route to each of the route table used by private subnets.
resource "aws_route" "private_vpn_routes" {
  for_each = data.terraform_remote_state.networking.outputs.private_route_tables

  route_table_id         = each.value.id
  destination_cidr_block = var.client_network
  instance_id            = module.openvpn.id
}
