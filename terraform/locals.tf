# ===================================================
# group and format server facts to be read by Ansible
# ===================================================

locals {
  control_nodes_facts = {
    for k, s in hcloud_server.control_nodes : k => {
      ipv4 = s.ipv4_address
      ipv6 = s.ipv6_address
    }
  }

  # will be read by Ansible
  control_servers = {
    for k, f in local.control_nodes_facts : k => {
      name         = k
      ipv4         = f.ipv4
      ipv6         = f.ipv6
      ssh_key_path = var.default_ssh_key_path
    }
  }

  worker_facts = {
    for k, s in hcloud_server.worker_nodes : k => {
      ipv4 = s.ipv4_address
      ipv6 = s.ipv6_address
    }
  }

  # will be read by Ansible
  worker_servers = {
    for k, f in local.worker_facts : k => {
      name         = k
      ipv4         = f.ipv4
      ipv6         = f.ipv6
      ssh_key_path = var.default_ssh_key_path
    }
  }
}
