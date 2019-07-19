# Terraform Digitalocean

Terraform to setup a droplet with nginx, docker, let's encrypt and DO monitoring.


## Prerequisites

* Terraform v0.12.4 - [https://www.terraform.io/](https://www.terraform.io/)
* Digital Ocean Token [https://www.digitalocean.com/docs/api/create-personal-access-token/](https://www.digitalocean.com/docs/api/create-personal-access-token/)

## Environment variables

* do_token - api token for digital ocean which can be found in your DigitalOcean Account under "API"
* ssh_fingerprint - the ssh fingerprint to use to connect to your newly created droplets

Exaple DO_TOKEN:

```
export DO_TOKEN=5f58.....
```

Get ssh_fingerprint:

```
$ ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'
```


## How to run

### Show plan

```
$  terraform validate
```

### Create plan

```
$  terraform plan -out=tfplan -input=false 
    -var "do_token=${DO_TOKEN}"
    -var "private_key_path=$HOME/.ssh/id_rsa"
    -var "ssh_fingerprint=${SSH_FINGERPRINT}" 
    -var "droplet_name=My_Droplet"     
```

### Show plan

```
$  terraform show
```


### Execute plan

```
$  terraform apply tfplan
```

If the Droplet already exists when you add these lines you will need to run

```
$  terraform refresh
```

### destroy

```
$  terraform destroy -input=false 
    -var "do_token=${DO_TOKEN}" 
    -var "private_key_path=$HOME/.ssh/id_rsa"
    -var "ssh_fingerprint=${SSH_FINGERPRINT}" 
    -var "droplet_name=My_Droplet"   
```

## Login

```
ssh root@$(terraform output droplet_ipv4)
```

## TODO

* copy script for execution
* copy configuration from file
* set up firewall
