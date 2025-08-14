# S3 bucket for storing dataset CSV files
resource "aws_s3_bucket" "dataset_bucket" {
  bucket = "dataset-csv-files-${random_string.dataset_bucket_suffix.result}"

  tags = {
    Name        = "Dataset CSV Bucket"
    Environment = var.environment
    Purpose     = "dataset-storage"
    DataType    = "csv-files"
  }
}

# Generate random suffix for dataset bucket name to ensure uniqueness
resource "random_string" "dataset_bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "dataset_bucket_encryption" {
  bucket = aws_s3_bucket.dataset_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access (recommended for data security)
resource "aws_s3_bucket_public_access_block" "dataset_bucket_pab" {
  bucket = aws_s3_bucket.dataset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM policy for dataset bucket access
resource "aws_iam_policy" "dataset_bucket_policy" {
  name        = "dataset-bucket-access-policy"
  description = "Policy for accessing dataset CSV files bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.dataset_bucket.arn,
          "${aws_s3_bucket.dataset_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach dataset policy to GitHub Actions role (reference existing role from terraform-state-bucket.tf)
resource "aws_iam_role_policy_attachment" "github_actions_dataset_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.dataset_bucket_policy.arn
}

# Outputs for the dataset bucket
output "dataset_bucket_name" {
  description = "Name of the S3 bucket for dataset CSV files"
  value       = aws_s3_bucket.dataset_bucket.bucket
}

output "dataset_bucket_arn" {
  description = "ARN of the dataset S3 bucket"
  value       = aws_s3_bucket.dataset_bucket.arn
}

output "dataset_bucket_url" {
  description = "URL of the dataset S3 bucket"
  value       = "s3://${aws_s3_bucket.dataset_bucket.bucket}"
}
