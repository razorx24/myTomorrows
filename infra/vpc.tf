locals {
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  vpc_azs             = var.vpc_azs
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.16"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs             = local.vpc_azs
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  #   private_subnets = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 4, k)]
  #   public_subnets  = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
}
