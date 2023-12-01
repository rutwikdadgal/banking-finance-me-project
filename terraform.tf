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

resource "aws_instance" "test_server" {
  ami           = "ami-02a2af70a66af6dfb"
  instance_type = "t2.micro"
  key_name      = "devops-key"
  
  tags = {
    Name = "test-server"
  }
}

resource "aws_instance" "prod_server" {
  ami           = "ami-02a2af70a66af6dfb"  
  instance_type = "t2.micro"
  key_name      = "devops-key"
  tags = {
    Name = "prod-server"
  }
}

output "test_server_ip" {
  value = aws_instance.test_server.public_ip
}

output "prod_server_ip" {
  value = aws_instance.prod_server.public_ip
}
