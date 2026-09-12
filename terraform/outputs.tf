output "bucket_name" {
  description = "Nome do bucket S3 criado no LocalStack"
  value       = aws_s3_bucket.app_bucket.id
}

output "bucket_arn" {
  description = "ARN (simulado) do bucket"
  value       = aws_s3_bucket.app_bucket.arn
}
