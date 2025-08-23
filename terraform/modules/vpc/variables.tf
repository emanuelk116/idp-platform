variable "name" {
  type        = string
  description = "Base name for resources"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

# variable "public_subnet_cidrs" {
#   type        = list(string)
#   description = "List of public subnet CIDRs"
# }

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}