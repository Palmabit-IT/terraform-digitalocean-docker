variable "do_token" {
  description = "DO Api token"
}

variable "ssh_fingerprint" {
  description = "SSH fingerprint to enable"
}

variable "private_key_path" {
  description = "private key path"
}

variable "droplet_name" {
  type        = "string"
  default     = "My App"
  description = "Droplet name"
}
