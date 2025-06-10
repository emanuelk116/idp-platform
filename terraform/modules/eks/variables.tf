variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_name" {
  type        = string
}

variable "cluster_version" {
  type        = string
  default     = "1.29"
}

variable "env" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "cluster_role_arn" {
  type        = string
}

variable "node_role_arn" {
  type        = string
}
