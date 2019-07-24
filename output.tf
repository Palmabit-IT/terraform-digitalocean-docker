
output "droplet_ipv4" {
  value = "${digitalocean_droplet.app-droplet.*.ipv4_address}"
}

output "droplet_id" {
  value = "${digitalocean_droplet.app-droplet.*.id}"
}

output "droplet_region" { 
  value = "${digitalocean_droplet.app-droplet.*.region}"  
}

output "droplet_size" { 
  value = "${digitalocean_droplet.app-droplet.*.size}" 
}

output "droplet_status" {
  value = "${digitalocean_droplet.app-droplet.*.status}" 
}
