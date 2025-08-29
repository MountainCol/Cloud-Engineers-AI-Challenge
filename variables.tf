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
  default     = "MountainCol/Cloud-Engineers-AI-Challenge"
}

# Knowledge Base Configuration
variable "knowledge_base_name" {
  description = "Name of the Bedrock Knowledge Base"
  type        = string
  default     = "Agri-Agent-Knowledge-Base"
}

variable "knowledge_base_role_arn" {
  description = "IAM role ARN for the Knowledge Base"
  type        = string
  sensitive   = true
}

variable "dataset_bucket_arn" {
  description = "ARN of the S3 bucket for the knowledge base data source"
  type        = string
  sensitive   = true
}

variable "embedding_model_arn" {
  description = "Bedrock embedding model ARN"
  type        = string
  default     = "arn:aws:bedrock:eu-west-2::foundation-model/amazon.titan-embed-text-v1"
}
