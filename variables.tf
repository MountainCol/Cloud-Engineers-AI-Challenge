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

variable "knowledge_base_name" {
  description = "Name for the Bedrock knowledge base"
  type        = string
  default     = "agri-agent-knowledge-base"
}

variable "knowledge_base_role_arn" {
  description = "IAM role ARN for the Bedrock knowledge base"
  type        = string
}

variable "embedding_model_arn" {
  description = "ARN of the embedding model for the knowledge base"
  type        = string
  default     = "arn:aws:bedrock:eu-west-2::foundation-model/amazon.titan-embed-text-v1"
}

variable "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection"
  type        = string
}
