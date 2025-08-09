variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"

}


variable "subnet_cidr" {
  type    = string
  default = "10.10.10.0/24"

}

variable "vpc_name" {
  type    = string
  default = "my_vpc"
}

variable "ami_name" {
  type    = string
  default = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = "aws-key-4aug2025-onedrive"

}

