resource "helm_release" "mytomorrows-app" {
  chart = "../helm/mytomorrows-app"
  name  = "test-tf-deploy"

  values = [
    templatefile("${path.cwd}/files/mytomorrows-values.yaml", {
      subnets = jsonencode(data.terraform_remote_state.eks.outputs.vpc_public_subnets)
    })
  ]
}