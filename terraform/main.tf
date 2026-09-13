resource "aws_s3_bucket" "app_bucket" {
  bucket = "api-agendamento-consultas-bucket"

  tags = {
    Project = "api-agendamento-consultas"
    Ambiente = "dev"
  }
}

# Versionamento habilitado: permite recuperar versoes anteriores de um objeto
resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Criptografia em repouso (server-side encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "app_bucket_encryption" {
  bucket = aws_s3_bucket.app_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloqueio de acesso publico - e' esse bloco que o Checkov valida.
# Comente este recurso propositalmente para testar o Checkov
resource "aws_s3_bucket_public_access_block" "app_bucket_block" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
