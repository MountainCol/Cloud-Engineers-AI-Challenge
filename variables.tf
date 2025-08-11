variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "github_repo" {
  description = "GitHub repository in format 'username/repo-name'"
  type        = string
  default     = "YOUR_GITHUB_USERNAME/YOUR_REPO_NAME"
}
