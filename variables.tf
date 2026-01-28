variable "bucket_name" {
  description = "Nom du bucket S3"
  type        = string
  default     = "mon-site-mohamed"
}

variable "environment" {
  description = "Environnement (dev, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "us-east-1"
}
