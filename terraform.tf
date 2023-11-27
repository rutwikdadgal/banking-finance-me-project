terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"  
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"  
}

resource "aws_instance" "test-server" {
  ami           = "ami-0287a05f0ef0e9d9a (64-bit (x86))"
  instance_type = "t2.micro"
  
  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} >> /etc/ansible/hosts"
  }
}

resource "aws_instance" "prod-server" {
  ami           = ""  
  instance_type = "t2.micro"
  
  tags = {
    Name = "prod-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.prod-server.public_ip} >> /etc/ansible/hosts"
  }
}
