packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:20.04"
  commit = true
  changes = [
      "EXPOSE 8080",
      "ENTRYPOINT [\"java\", -\"jar\", \"/home/Calculator.jar\"]"
    ]
}

variable "username" {
  type = string
  default = ""
}

variable "password" {
  type = string
  default = ""
}

build {
  name    = "Job2"
  sources = [
    "source.docker.ubuntu"
  ]
  
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install ansible -y",
    ]
  }
  
  provisioner "file" {
    source = "./Calculator.jar"
    destination = "/home/Calculator.jar"
  }
  
  provisioner "ansible" {
     playbook_file = "./playbook.yml"
  }
  
  post-processors {
    post-processor "docker-tag" {
        repository =  "yagojanos/temafinal1"
        tags = ["0.1"]
    }
    post-processor "docker-push" {
        login = true
        login_username = var.username
        login_password = var.password
    }
  }
}
