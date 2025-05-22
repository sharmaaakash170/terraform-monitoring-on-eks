variable "project_name" {
  type = string
}

variable "eks_role_arn" {
  type = string
}

variable "eks_node_role_arn" {
  type = string
}

variable "subnet_ids" {
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
