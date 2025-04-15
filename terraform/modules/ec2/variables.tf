variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}