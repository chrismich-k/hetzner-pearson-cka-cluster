# ========================================================
# create new nodes or query existing nodes; attach network
# ========================================================

## master nodes

# create new cloud instance, always public ipv4+ipv6
resource "hcloud_server" "control_nodes" {
  for_each = {
    for k, v in var.cluster_nodes : k => v if v.role == "control"
  }

  name        = each.key
  server_type = var.server_type
  location    = var.hcloud_location
  image       = var.hcloud_node_image
  ssh_keys    = [data.hcloud_ssh_key.main_ssh_key.id] # [hcloud_ssh_key.admin.id]
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
  ssh_keys    = [data.hcloud_ssh_key.main_ssh_key.id] # [hcloud_ssh_key.admin.id]
}

## attach network to nodes

# hcloud control nodes: join private network
resource "hcloud_server_network" "control_node_network" {
  for_each = hcloud_server.control_nodes

  server_id  = each.value.id
  network_id = hcloud_network.k8s_net.id
  ip         = var.cluster_nodes[each.key].ipv4_priv
}

# hcloud worker nodes: join private network
resource "hcloud_server_network" "worker_node_network" {
  for_each = hcloud_server.worker_nodes

  server_id  = each.value.id
  network_id = hcloud_network.k8s_net.id
  ip         = var.cluster_nodes[each.key].ipv4_priv
}
