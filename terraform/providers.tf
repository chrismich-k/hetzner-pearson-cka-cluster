terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }
  # no feature used here strictly needs 1.9.0, it's just a reasonable lower bound
  required_version = ">= 1.9.0"
}

provider "hcloud" {
  token = var.hcloud_token
}
