output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "ecr_repo_arn" {
  description = "ARN of the ECR Repo"
  value       = module.ecr.repository_arn
}

