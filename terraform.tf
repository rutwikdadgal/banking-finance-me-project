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
 
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_instance" "test_server" {
  ami           = "ami-02a2af70a66af6dfb"
  instance_type = "t2.micro"
  key_name      = "devops-key"
  
  subnet_id = aws_subnet.main_subnet.id

  tags = {
    Name = "test-server"
  }
}

resource "aws_instance" "prod_server" {
  ami           = "ami-02a2af70a66af6dfb"  
  instance_type = "t2.micro"
  key_name      = "devops-key"
  subnet_id     = aws_subnet.main_subnet.id

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

