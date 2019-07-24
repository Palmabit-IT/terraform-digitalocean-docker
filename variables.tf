variable "do_token" {
  description = "DO Api token"
}

variable "ssh_fingerprints" {
  type    = list(string)
  description = "SSH fingerprint to enable"
}

variable "private_key_path" {
  description = "private key path"
}

variable "droplet_name" {
  default     = "terraform-digitalocean-ubuntu-docket-gitlab"
}

variable "droplet_nums" {
  default = 1
}

variable "droplet_image" {
  default = "ubuntu-18-04-x64"
}

variable "droplet_region" {
  default = "fra1"
}
variable "droplet_size" {
  default = "s-1vcpu-1gb"
}

variable "droplet_private_networking" {
  default = false
}

variable "droplet_backup" {
  default = false
}
variable "droplet_monitoring" {
  default = true
}
variable "droplet_ipv6" {
  default = false
}
