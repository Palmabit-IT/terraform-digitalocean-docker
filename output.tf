
output "droplet_ipv4" {
  value = "${digitalocean_droplet.app-droplet.ipv4_address}"
}

output "droplet_id" {
  value = "${digitalocean_droplet.app-droplet.id}"
}