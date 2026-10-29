
output "control_nodes" {
  value = local.control_servers
}

output "worker_nodes" {
  value = local.worker_servers
}

# Not a secret - lets each control node know whether it is the one that
# currently bootstraps the cluster; every other master joins through it.
output "primary_control_node" {
  value = var.primary_control_node
}

# Not a secret - lets roles/ipv4_gateway source the subnet it routes/NATs for
# directly from ip_range_sub_hcloud instead of duplicating it as a hardcoded
# role default that has to be kept in sync by hand.
output "ip_range_sub_hcloud" {
  value = var.ip_range_sub_hcloud
}

# Not a secret - the first usable address of ip_range_net_private, which is
# the real next-hop Hetzner's own DHCP announces for the whole private CIDR
# to hcloud nodes (confirmed via `ip route show` on any hcloud node). Computed
# here so roles/ipv4_route_via_gateway's hetzner_private_network_gateway_ip
# always tracks ip_range_net_private instead of being hardcoded separately.
output "hetzner_private_network_gateway_ip" {
  value = cidrhost(var.ip_range_net_private, 1)
}

# Not a secret - raw passthrough of the whole private-network CIDR, so
# roles/hrobot_vswitch_vlan's hetzner_private_network_cidr can source it
# directly instead of duplicating the literal.
output "ip_range_net_private" {
  value = var.ip_range_net_private
}

# Single source of truth for the Hetzner credentials that Ansible also needs
# (e.g. to create the "hcloud" k8s Secret consumed by HCCM/CSI). Marked
# sensitive so plain `terraform output`/plan/apply logs redact them; `-json`
# still includes the real values, which is what 00_setup_inventory.yaml uses.
output "hcloud_token" {
  value     = var.hcloud_token
  sensitive = true
}
