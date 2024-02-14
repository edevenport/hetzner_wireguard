variable "hcloud_token" {
  sensitive = true
}

variable "wg_server_private_key" {}
variable "wg_server_public_key" {}
variable "wg_client_private_key" {}
variable "wg_client_public_key" {}
variable "wg_subnet_cidr" { default = "192.168.10.0/24" }

variable "server_name" { default = "wireguard" }
variable "server_type" {}
variable "image" {}
variable "image_username" { default = "root" }
variable "datacenter" {}
variable "ssh_key_path" {}
