# ------------------------------------------------------------------------------
# Data sources
# ------------------------------------------------------------------------------
data "cloudinit_config" "cloud_config" {
  part {
    content_type = "text/cloud-config"
        content      = yamlencode(
          {
            "packages": ["wireguard"],
            "write_files": [
                  {
                    "path": "/etc/wireguard/private.key",
                        "content": var.wg_server_private_key,
                        "permissions": "0600"
                  },
                  {
                    "path": "/etc/wireguard/public.key",
                        "content": var.wg_server_public_key,
                        "permissions": "0600"
                  }
                ],
                "runcmd": [
                  "sysctl -w sysctl -w net.ipv4.ip_forward=1",
                  "ip link add wg0 type wireguard",
          "ip address add dev wg0 ${cidrhost(var.wg_subnet_cidr, 1)}/${local.wg_netmask_bits}",
                  "ip link set mtu 65456 up dev wg0",
                  "iptables -A FORWARD -i wg0 -j ACCEPT",
                  "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"
                ]
          }
        )
  }
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "hcloud_ssh_key" "default" {
  name       = "wireguard-server"
  public_key = module.ssh_keygen.public_key
}

resource "hcloud_firewall" "wireguard" {
  name = "wireguard-fw"

  # Allow incoming ICMP (ping, etc.)
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming SSH
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming Wireguard connections
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "wireguard" {
  name         = var.server_name
  image        = var.image
  server_type  = var.server_type
  datacenter   = var.datacenter
  user_data    = data.cloudinit_config.cloud_config.rendered
  ssh_keys     = [ hcloud_ssh_key.default.name ]
  firewall_ids = [hcloud_firewall.wireguard.id]

  labels = {
    "app" : "wireguard"
  }
}

# ------------------------------------------------------------------------------
# Local variables
# ------------------------------------------------------------------------------
locals {
  wg_netmask_bits = split("/", var.wg_subnet_cidr)[1]
}
