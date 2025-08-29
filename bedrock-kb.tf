resource "aws_bedrockagent_knowledge_base" "bedrock_kb-Farm-AI-Agent" {
  name     = var.knowledge_base_name
  role_arn = var.knowledge_base_role_arn

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = var.embedding_model_arn
    }
  }

  storage_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.dataset_bucket_arn
    }
  }
}
