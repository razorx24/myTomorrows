locals {
  image_count     = var.ecr_image_count
  repository_name = var.ecr_repository_name
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.3"

  repository_name = local.repository_name

  repository_read_write_access_arns = [module.eks.cluster_iam_role_arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last num of images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = local.image_count
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
