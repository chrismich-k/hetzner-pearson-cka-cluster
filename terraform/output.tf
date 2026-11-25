
output "control_nodes" {
  value = local.control_servers
}

output "worker_nodes" {
  value = local.worker_servers
}

# the control node to run kubeadm init on, all other nodes join it
output "primary_control_node" {
  value = local.primary_control_node
}

# use as kubeadm init --control-plane-endpoint "<ipv4>:6443"; null for exam2
# (null outputs are left out of `terraform output -json` entirely)
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
