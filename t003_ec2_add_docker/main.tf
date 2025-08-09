provider "aws" {
  region = "us-east-1"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "instance_type" {}
variable "ami_name" {}
variable "key_name" {}



resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-route-table"
  }

}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }

}

resource "aws_route_table_association" "myapp-rt-assoc" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id

}


resource "aws_security_group" "myapp_sg" {
  name        = "myapp-sg"
  description = "Security group for my app"
  vpc_id      = aws_vpc.myapp-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "myapp-server" {
  ami           = var.ami_name
  instance_type = var.instance_type

  subnet_id              = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp_sg.id]
  availability_zone      = var.avail_zone

  key_name                    = var.key_name
  associate_public_ip_address = true

  # Install Docker
  # Start Docker service
  # Add ubuntu user to docker group
  # Run Nginx container

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              usermod -aG docker ubuntu
              docker run -d -p 8080:80 nginx
              EOF

  tags = {
    Name = "${var.env_prefix}-server"
  }

}

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip

}

output "vpc_id" {
  value = aws_vpc.myapp-vpc.id
}
output "subnet_id" {
  value = aws_subnet.myapp-subnet-1.id
}
output "security_group_id" {
  value = aws_security_group.myapp_sg.id
}
output "route_table_id" {
  value = aws_route_table.myapp-route-table.id
}
output "ami_id" {
  value = aws_instance.myapp-server.id

}
