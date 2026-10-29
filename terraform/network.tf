# =================================================
# create private Hetzner network and subnets, route
# =================================================

# create new private network; hetzner console equivalent:
# https://console.hetzner.com/projects/<project_id>/networks
resource "hcloud_network" "k8s_net" {
  name                     = var.hetzner_network_name
  ip_range                 = var.ip_range_net_private
  expose_routes_to_vswitch = true
}

# create subnets; in hetzner console:
# https://console.hetzner.com/projects/<project_id>/networks/<network_id>/subnets

# subnet for hcloud instances
resource "hcloud_network_subnet" "cloud_subnet" {
  network_id   = hcloud_network.k8s_net.id
  type         = "cloud"
  network_zone = var.hcloud_network_zone
  ip_range     = var.ip_range_sub_hcloud
}
