# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

provider "hcloud" {
  token = var.hcloud_token
}

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "ssh_keygen" {
  source = "github.com/edevenport/tf_ssh_keygen"

  ssh_key_path = var.secrets_path
}
