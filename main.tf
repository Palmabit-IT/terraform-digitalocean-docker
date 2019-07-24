# Droplet resources
resource "digitalocean_droplet" "app-droplet" {
  count              = "${var.droplet_nums}"
  name               = "${var.droplet_name}-${count.index}"
  image              = "${var.droplet_image}"
  region             = "${var.droplet_region}"
  size               = "${var.droplet_size}"
  private_networking = "${var.droplet_private_networking}"
  backups            = "${var.droplet_backup}"
  monitoring         = "${var.droplet_monitoring}"
  ipv6               = "${var.droplet_ipv6}"
  ssh_keys           = "${var.ssh_fingerprints}"

  connection {
    user        = "root"
    private_key = "${file(var.private_key_path)}"
    type        = "ssh"
    host        = "${self.ipv4_address}"
    agent       = true
    timeout     = "2m"
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
      "curl -fsSL https://get.docker.com/ | sh",
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

  # Enable DO Monitoring
  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash"
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

  # Add Gitlab User
  provisioner "remote-exec" {
    inline = [
      "useradd -m gitlab",
      "mkdir /home/gitlab/.ssh",
      "chmod 700 /home/gitlab/.ssh",
      "touch /home/gitlab/.ssh/authorized_keys",
      "chmod 600 /home/gitlab/.ssh/authorized_keys",
      "ssh-keygen -b 2048 -t rsa -f /home/gitlab/.ssh/id_rsa -q -N ''",
      "cat /home/gitlab/.ssh/id_rsa.pub >> /home/gitlab/.ssh/authorized_keys",
      "chown -R gitlab:gitlab /home/gitlab/.ssh",
    ]
  }

  # give gitlab user permission to run docker cmds

  provisioner "remote-exec" {
    inline = [
      "sudo groupadd docker",
      "sudo usermod -aG docker gitlab"
    ]
  }


}
