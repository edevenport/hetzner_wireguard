output "public_ip" {
  value = hcloud_server.wireguard.ipv4_address
}
