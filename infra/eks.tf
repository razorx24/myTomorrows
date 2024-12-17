locals {
  name            = "dev-cluster"
  cluster_version = "1.31"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # Grant k8s API access permissions to IAM principals
  access_entries = {
    console-admin-access = {
      principal_arn = "arn:aws:iam::172221322213:user/max"
      type          = "STANDARD"
      policy_associations = {
        ClusterAdmin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

}

# resource "aws_eks_access_entry" "my_eks_entry" {
#   cluster_name      = "dev-cluster"
#   principal_arn     = "arn:aws:iam::172221322213:user/max"
#   type              = "STANDARD"
#   user_name         = "arn:aws:iam::172221322213:user/max"
# }
