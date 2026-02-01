resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.deployment_id != "" ? "app-logs-bucket-${var.deployment_id}" : "app-logs-bucket-080126"

  tags = {
    Name        = var.deployment_id != "" ? "s3-logs-bucket-${var.deployment_id}" : "s3-logs-bucket"
    Environment = "production"
    Project     = "ECS-Threat-Modelling-App"
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "logs_bucket_public_access" {
    bucket = aws_s3_bucket.logs_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_bucket_lifecycle" {
    bucket = aws_s3_bucket.logs_bucket.id

    rule {
        id = var.deployment_id != "" ? "log-expiration-rule-${var.deployment_id}" : "log-expiration-rule"
        status = "Enabled"

        filter {} 
        expiration {
            days = 30
        }
    }
}

data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "logs_bucket_policy" {
    bucket = aws_s3_bucket.logs_bucket.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    AWS = data.aws_elb_service_account.main.arn
                }
                Action = "s3:PutObject"
                Resource = "${aws_s3_bucket.logs_bucket.arn}/alb-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
            }
        ]
    })
}