### VPC

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR of the VPC"
}

variable "vpc_azs" {
  type        = list(string)
  description = "List of Availability zones to create VPC subnets"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "List of private subnets to create in VPC"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "List of public subnets to create in VPC"
}

### ECR

variable "ecr_image_count" {
  type        = number
  description = "The maximum number of images that you want to retain"
}