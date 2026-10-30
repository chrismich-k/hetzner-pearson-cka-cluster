
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

# Single source of truth for the Hetzner credentials that Ansible also needs
# (e.g. to create the "hcloud" k8s Secret consumed by HCCM/CSI). Marked
# sensitive so plain `terraform output`/plan/apply logs redact them; `-json`
# still includes the real values, which is what 00_setup_inventory.yaml uses.
output "hcloud_token" {
  value     = var.hcloud_token
  sensitive = true
}
