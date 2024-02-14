# tf_hetzner_wireguard

## Description

Creates a server on Hetzner Online and deploys Wireguard.

## Usage

Example `terraform.tfvars`

```
hcloud_token          = "API_TOKEN"
wg_server_private_key = "WIREGUARD_SERVER_PRIVATE_KEY"
wg_server_public_key  = "WIREGUARD_SERVER_PUBLIC_KEY"
wg_client_private_key = "WIREGUARD_CLIENT_PRIVATE_KEY"
wg_client_public_key  = "WIREGUARD_CLIENT_PUBLIC_KEY"
wg_subnet_cidr        = "192.168.10.0/24"
server_name           = "wireguard"
server_type           = "cpx11"
image                 = "ubuntu-22.04"
datacenter            = "hil-dc1"
secret_path           = "/path/to/secrets"
```

Stores SSH keys and Wireguard config in `secrets_path`.

## Notes

* Wireguard configuration will not survive a server reboot at this time.
