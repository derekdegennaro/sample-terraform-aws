provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Module      = "sample-s3-app"
      Environment = var.environment
    }
  }
}

variable "aws_region" {
  description = "AWS region where the sample bucket will be created."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment label applied to resources as a tag."
  type        = string
  default     = "demo"
}


# bucket_prefix generates a unique name automatically (e.g. "sample-s3-app-20240101abc").
# The IAM role in setup/ is scoped to "sample-s3-app-*" to match this prefix.
resource "aws_s3_bucket" "sample" {
  bucket_prefix = "sample-s3-app-"
}

resource "aws_s3_bucket_versioning" "sample" {
  bucket = aws_s3_bucket.sample.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sample" {
  bucket = aws_s3_bucket.sample.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "sample" {
  bucket = aws_s3_bucket.sample.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
