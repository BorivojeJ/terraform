terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
    
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "eu-WEST-ec2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id= "subnet-0d232f40d222f6ed7"
    tags = {
        Name = "B&B"
    }
    key_name = aws_key_pair.Kljuc.key_name
    vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
}

resource "aws_key_pair" "Kljuc" {
    key_name = "B&B"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5DneN9+SkBRqqGtyT8Gh7T3gcbuAov4I+pviw45Mf2Y83LG6fTWXxPtvCR1h4o2m6qdHj5CCyvtJhVY2t4j6EpjHHUMQ57i1gACPt6rqesc36+lmCyiJtiEjZbflxW6Y1rhgvbbUo5lQjJwljiOpdfvd9cxFVoOewv/UvN7izY3jw4CdWbUHpthM04AgdYEBgg5bQqnCzV55yw3vHIfh5YCYN/3y36U/CBFfi9GHulR+sty5RNcNSq3f7sjdDbdP7VaYqZ2j5S9HObGHTuRi1Hcma/Nu9f/WVWuMtrBsimhm3tdxcICFwLGhe/TjlStmbcBM4D2IA8rrOEp9m0FHMHrcE7e0FO2Rvw6spJS4ryPoG07RjcuPFR7KLqk++KdKRy8hoOZHEmJv5LxGzzWk8/47qH+OKc3gD5QwUKNr5HeZ+eY4uXYA9004TwTSAN7ebssnSiCXf23LTvI7X++iRtLwDU/np0nDO/TjH3R7+u678CY0T1Zr8ucmJ1NvlL20= devopslinux@DevOps"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-03533bf42250b44e7"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["94.230.187.74/32"]
  }
  tags = {
    Name = "allow_tls"
  }
}