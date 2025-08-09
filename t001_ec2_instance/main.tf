provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "mySubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_cidr
  tags       = { Name = "mySubnet" }

}

resource "aws_security_group" "mySG" {
  #get the newly created vpc id
  name   = "allow ssh"
  vpc_id = aws_vpc.myvpc.id
  tags   = { Name = "mySG" }

  # allow all inbound traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami             = var.ami_name
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.mySubnet.id
  key_name        = var.key_name
  security_groups = [aws_security_group.mySG.id]
}
