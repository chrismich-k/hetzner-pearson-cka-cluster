# ================
# create new nodes
# ================

## control nodes

# create new cloud instance, always public ipv4+ipv6
resource "hcloud_server" "control_nodes" {
  for_each = {
    for k, v in var.cluster_nodes : k => v if v.role == "control"
  }

  name        = each.key
  server_type = var.server_type
  location    = var.hcloud_location
  image       = var.hcloud_node_image
  ssh_keys    = [data.hcloud_ssh_key.main_ssh_key.id]
}

## worker nodes

# create new cloud instance, always public ipv4+ipv6
resource "hcloud_server" "worker_nodes" {
  for_each = {
    for k, v in var.cluster_nodes : k => v if v.role == "worker"
  }

  name        = each.key
  server_type = var.server_type
  location    = var.hcloud_location
  image       = var.hcloud_node_image
  ssh_keys    = [data.hcloud_ssh_key.main_ssh_key.id]
}
