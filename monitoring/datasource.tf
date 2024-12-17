data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../infra/terraform.tfstate"
  }
}