resource "null_resource" "wg_add_peer" {
  connection {
    type        = "ssh"
    user        = var.image_username
    host        = hcloud_server.wireguard.ipv4_address
    private_key = module.ssh_keygen.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "wg set wg0 listen-port 51820 private-key /etc/wireguard/private.key peer ${var.wg_client_public_key} allowed-ips ${cidrhost(var.wg_subnet_cidr, 2)}/32"
    ]
  }
}
