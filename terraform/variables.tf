variable "hcloud_token" {
  type        = string
  sensitive   = true
  description = "Hetzner Cloud API Token"
}

variable "ssh_key_name" {
  type        = string
  description = "name of the ssh key to use for new hcloud servers at Hetzner"
}

variable "default_ssh_key_path" {
  type        = string
  description = "local path to the default ssh key to use for login to a server"
}

variable "hcloud_node_image" {
  type        = string
  description = "default distribution to use for new hcloud nodes"
  default     = "ubuntu-26.04"
}

variable "cluster_nodes" {
  type = map(object({
    role         = string # "control" or "worker"
    ipv4_priv    = string # pinned private IP, required for every node
  }))

}

# cluster_nodes key of the prinary cobtrol node that starts the embedded-etcd cluster;
# every other control node joins through it.
variable "primary_control_node" {
  type        = string
  description = "cluster_nodes key of the control node that bootstraps the cluster"

  validation {
    condition     = contains([for k, v in var.cluster_nodes : k if v.role == "control"], var.primary_control_node)
    error_message = "primary_control must name an existing cluster_nodes entry with role = \"control\"."
  }
}

variable "hetzner_network_name" {
  type        = string
  description = "the name of the private network that will be created in the Hetzner Cloud"
}

variable "ip_range_net_private" {
  default = "10.0.0.0/16"
}

variable "ip_range_sub_hcloud" {
  default = "10.0.1.0/24"
}

variable "hcloud_location" {
  type    = string
  default = "fsn1"
}

variable "server_type" {
  type = string
  default = "cpx22" # or the cheaper cx23 if available
}

variable "hcloud_network_zone" {
  type    = string
  default = "eu-central"
}
