output "url" {
  description = "ECR Repository Url"
  value =  aws_ecr_repository.repository.repository_url
}