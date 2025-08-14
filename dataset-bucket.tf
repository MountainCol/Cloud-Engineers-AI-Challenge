# S3 bucket for storing Terraform state files
resource "aws_s3_bucket" "dataset_bucket" {
  bucket = "dataset_bucket-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "Dataset Bucket"
    Environment = "production"
    Purpose     = "dataset-storage"
  }
}

# Generate random suffix for bucket name to ensure uniqueness
resource "random_string" "bucket_suffix" {
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

# Block public access
resource "aws_s3_bucket_public_access_block" "dataset_bucket_pab" {
  bucket = aws_s3_bucket.dataset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-dataset-bucket-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:MountainCol/Cloud-Engineers-AI-Challenge:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "GitHub Actions Dataset Bucket Role"
  }
}

# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]

  tags = {
    Name = "GitHub Actions OIDC Provider"
  }
}

# IAM policy for S3 access
resource "aws_iam_policy" "github_actions_s3_policy" {
  name        = "github-actions-dataset-bucket-s3-policy"
  description = "Policy for GitHub Actions to access Dataset S3 bucket"

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

# Attach policy to role
resource "aws_iam_role_policy_attachment" "github_actions_s3_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_s3_policy.arn
}

# Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket for Dataset"
  value       = aws_s3_bucket.dataset_bucket.bucket
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.dataset_bucket.arn
}
