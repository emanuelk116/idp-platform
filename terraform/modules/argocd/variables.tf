variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca" {
  type        = string
  description = "EKS cluster CA (base64 encoded)"
}

variable "cluster_auth_token" {
  type        = string
  description = "Authentication token for EKS cluster"
}
