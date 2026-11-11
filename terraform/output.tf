
output "control_nodes" {
  value = local.control_servers
}

output "worker_nodes" {
  value = local.worker_servers
}

# Not a secret - lets each control node know whether it is the one that
# currently bootstraps the cluster; every other master joins through it.
output "primary_control_node" {
  value = local.primary_control_node
}

# Single source of truth for the Hetzner credentials that Ansible also needs
# (e.g. to create the "hcloud" k8s Secret consumed by HCCM/CSI). Marked
# sensitive so plain `terraform output`/plan/apply logs redact them; `-json`
# still includes the real values, which is what 00_setup_inventory.yaml uses.
output "hcloud_token" {
  value     = var.hcloud_token
  sensitive = true
}

# use as kubeadm init --control-plane-endpoint "<ipv4>:6443"; null for exam2
output "k8s_api_lb" {
  value = local.k8s_api_lb ? {
    ipv4 = hcloud_load_balancer.k8s_api[0].ipv4
    ipv6 = hcloud_load_balancer.k8s_api[0].ipv6
    port = hcloud_load_balancer_service.k8s_api[0].listen_port
  } : null
}

# "exam1" | "exam2" - e.g. for naming the access README Ansible writes
output "exam" {
  value = var.exam
}
