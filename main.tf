# Droplet resources
resource "digitalocean_droplet" "app-droplet" {
  name       = "${var.droplet_name}"
  image      = "ubuntu-18-04-x64"
  region     = "fra1"
  size       = "s-1vcpu-1gb"
  backups    = true
  monitoring = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user        = "root"
    private_key = "${file(var.private_key_path)}"
    type        = "ssh"
    host    = "${self.ipv4_address}"
    agent   = true
    timeout = "2m"
  }

  # Enable DO Monitoring
  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
  }

  # Install NGINX, Docker and Certbot
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      # Install NGINX
      "sudo apt install -y nginx unzip zip",
      "sudo ufw allow 'Nginx Full'",
      "sudo ufw enable -y",
      # install Docker
      "snap install docker",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "docker-compose version",
      # Install Certbot - Let's Encrypt
      "sudo apt-get update",
      "sudo apt-get install -y -q software-properties-common",
      "sudo add-apt-repository -y universe",
      "sudo add-apt-repository -y ppa:certbot/certbot",
      "sudo apt-get update",
      "sudo apt-get install -y python-certbot-nginx"
    ]
  }

  # Copies the nginx.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "resources/nginx.conf"
    destination = "/etc/nginx/sites-available/default" // copy to different location then overwrite
  }

  # Restart NGINX
  provisioner "remote-exec" {
    inline = [
      "sudo /etc/init.d/nginx restart"
    ]
  }

}
