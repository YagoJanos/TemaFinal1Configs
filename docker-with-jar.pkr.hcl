packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:xenial"
  commit = true
  changes = [
      "EXPOSE 8080",
      "ENTRYPOINT [\"java\", -\"jar\", \"/home/Calculator.jar\"]
    ]
}

build {
  name    = "Job2"
  sources = [
    "source.docker.ubuntu"
  ]
  
  provisioner "shell" {
    inline = [
      "apt update",
      "apt install -y ansible",
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
        login_username = ""
        login_password = ""
    }
  }
}
