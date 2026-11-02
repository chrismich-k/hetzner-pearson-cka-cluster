# =========================================================
# load balancer for the Kubernetes API (control-plane-endpoint)
# =========================================================

# replaces the course's haproxy + keepalived setup (setup-lb-ubuntu.sh):
# keepalived needs an ARP/layer-2 VIP, which Hetzner Cloud doesn't support.
# Only exam1 has more than one control node to balance across
resource "hcloud_load_balancer" "k8s_api" {
  count = local.k8s_api_lb ? 1 : 0

  name               = var.k8s_api_lb_name
  load_balancer_type = var.k8s_api_lb_type
  location           = var.hcloud_location
}

# plain TCP passthrough - TLS is terminated by the kube-apiservers themselves
resource "hcloud_load_balancer_service" "k8s_api" {
  count = local.k8s_api_lb ? 1 : 0

  load_balancer_id = hcloud_load_balancer.k8s_api[0].id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443
    interval = 5
    timeout  = 3
    retries  = 3
  }
}

# no private network, so the LB reaches the control nodes via their public IPs
resource "hcloud_load_balancer_target" "k8s_api" {
  for_each = local.k8s_api_lb ? hcloud_server.control_nodes : {}

  type             = "server"
  load_balancer_id = hcloud_load_balancer.k8s_api[0].id
  server_id        = each.value.id
  use_private_ip   = false
}
