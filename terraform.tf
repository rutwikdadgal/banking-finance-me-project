terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"  
    }
  }
}

provider "aws" {
  region = "ap-south-1"  
}

resource "aws_instance" "test-server" {
  ami           = "ami-02a2af70a66af6dfb"
  instance_type = "t2.micro"
  
  tags = {
    Name = "test-server"
  }
}

resource "aws_instance" "prod-server" {
  ami           = "ami-02a2af70a66af6dfb"  
  instance_type = "t2.micro"
  
  tags = {
    Name = "prod-server"
  }
}
  
resource "null_resource" "configure-ansible-hosts" {
  depends_on = [aws_instance.test-server, aws_instance.prod-server]

  provisioner "local-exec" {
    command = <<EOT
      sudo mkdir -p /etc/ansible
      echo "${aws_instance.test-server.public_ip}" >> /etc/ansible/hosts
      echo "${aws_instance.prod-server.public_ip}" >> /etc/ansible/hosts
    EOT
  }
}


