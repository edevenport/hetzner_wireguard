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

resource "local_sensitive_file" "wg_client_config" {
  content  = <<-EOF
	[Interface]
    PrivateKey = ${var.wg_client_private_key}
    Address = ${cidrhost(var.wg_subnet_cidr, 2)}/32
    DNS = 1.1.1.1
    
    [Peer]
    PublicKey = ${var.wg_server_public_key}
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint = ${hcloud_server.wireguard.ipv4_address}:51820
  EOF

  filename = "${var.secrets_path}/wg_client.conf"
}
