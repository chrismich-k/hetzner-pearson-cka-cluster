# ===================================================
# group and format server facts to be read by Ansible
# ===================================================

locals {
  control_nodes_facts = {
    for k, s in hcloud_server.control_nodes : k => {
      provider_id = s.id
      ipv4        = s.ipv4_address
      ipv6        = s.ipv6_address
      ipv4_priv   = hcloud_server_network.control_node_network[k].ip
    }
  }

  # will be read by Ansible
  control_servers = {
    for k, f in local.control_nodes_facts : k => {
      name           = k
      wan_ip         = f.ipv4
      ipv4           = f.ipv4
      ipv6           = f.ipv6
      ipv4_priv      = f.ipv4_priv
      ssh_key_path   = var.default_ssh_key_path
      provider_id    = tostring(f.provider_id)
    }
  }

  ## group agent nodes
  agent_nodes = {
    for k, v in var.cluster_nodes : k => v if v.role == "agent"
  }

  worker_facts ={
    for k, s in hcloud_server.worker_nodes : k => {
      provider_id = s.id
      ipv4        = s.ipv4_address
      ipv6        = s.ipv6_address
      ipv4_priv   = hcloud_server_network.worker_node_network[k].ip
    }
  }

  # will be read by Ansible
  worker_servers = {
    for k, f in local.worker_facts : k => {
      name           = k
      wan_ip         = f.ipv4
      ipv4           = f.ipv4
      ipv6           = f.ipv6
      ipv4_priv      = f.ipv4_priv
      ssh_key_path   = var.default_ssh_key_path
      provider_id    = tostring(f.provider_id)
    }
  }

  hcloud_network_mask = split("/", hcloud_network.k8s_net.ip_range)[1]
}
