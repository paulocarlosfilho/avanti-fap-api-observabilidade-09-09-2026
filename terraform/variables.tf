variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "app-aponti-fap-observabilidade-s3"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}