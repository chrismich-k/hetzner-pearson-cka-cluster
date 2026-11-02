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

variable "exam" {
  type        = string
  description = "cluster layout to provision, see exams.tf"
  default     = "exam1"

  validation {
    condition     = contains(["exam1", "exam2"], var.exam)
    error_message = "exam must be \"exam1\" or \"exam2\"."
  }
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

variable "k8s_api_lb_name" {
  type        = string
  description = "name of the Hetzner load balancer in front of the kube-apiservers"
  default     = "cka-k8s-api"
}

variable "k8s_api_lb_type" {
  type        = string
  description = "Hetzner load balancer type"
  default     = "lb11" # smallest one, plenty for a lab cluster
}
