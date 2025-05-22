variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  
}

variable "vpc_cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "k8s_version" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "desired_size" {
  type = number
}

