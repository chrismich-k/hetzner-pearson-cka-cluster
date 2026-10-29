terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  # >= 1.9.0 needed for variable validation blocks that reference other
  # variables (see primary_control in variables.tf)
  required_version = ">= 1.9.0"
}

provider "hcloud" {
  token = var.hcloud_token
}
