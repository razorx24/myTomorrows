### EKS

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate data"
  value       = module.eks.cluster_certificate_authority_data
}

### VPC

output "vpc_public_subnets" {
  description = " List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

### ECR

output "ecr_repo_arn" {
  description = "ARN of the ECR Repo"
  value       = module.ecr.repository_arn
}
