output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.webapp_repo.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.webapp_repo.arn
}

output "registry_id" {
  description = "Registry ID of the ECR repository"
  value       = aws_ecr_repository.webapp_repo.registry_id
}
