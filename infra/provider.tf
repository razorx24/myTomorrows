terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }

}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "DevOpsAssignment"
      Owner       = "MNaidzin"
      Email       = "razor.x2424@gmail.com"
      Source      = "/mytomorrows/infra"
    }
  }
}