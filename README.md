## DevOps Assignment

The Repository contains the codebase to deploy a Flask app into a Kubernetes cluster. The app itself can be found at https://github.com/myTomorrows/devops-assignment.git and is included as a submodule in /build/devops-assignment

== All Terraform code was running from an EC2 IaC-machine with instance profile attached. IAM role with permissions to create, describe and delete resources would have to be supplied separately ==

Overview of directory structure, in steps-to-deploy order:
- `/infra` Terraform module to create all the necessary resources in the AWS. .
- `/build` Source application code, Dockerfile to build an image. `build.sh` script that will build an image, tag it and push to ECR repo. Compose file is in place to allow debugging on a local machine.
- `/helm` Source code for the Helm chart 
- `/deployment` Terraform module to handle Application deployment into the EKS cluster
- `/monitoring` Terraform module to handle kube-prometheus-stak monitoring deployment into the EKS cluster
- `/monitoring/k8s` Ad-hoc Ingress manifest for Grafana dashboard. One can Never do that in production!

## Endpoints
k8s Ingress resource is created in order to expose the application to the internet. Due to lack of a dedicated domain name it can be accessible via AWS ALB's cname.\
Two application endpoints are exposed (only http listeners available):
- http://k8s-default-testtfde-cad7bf73ca-1563891471.us-east-1.elb.amazonaws.com
- http://k8s-default-testtfde-cad7bf73ca-1563891471.us-east-1.elb.amazonaws.com/config

## Observability 
`kube-prometheus-stack` (Prometheus, Grafana) is deployed inside of the cluster to provide cluster-wide and application observability :
- http://k8s-monitori-monitori-ea155b804d-1327423129.us-east-1.elb.amazonaws.com [ admin | prom-operator ] 

## Security
- Application pods are schedued to internal subnets that have access to the Internet through NAT Gateway to allow package upgrades but can not be accessible from outside. Incoming traffic goes through the ALB deployed in public subnets.
- Sensitive credentials are dynamically-generated (actually just one of them at the moment of writing :| ) and are not exposed in the source code.

## Availability
- k8s Deployment nodeSelector has three subnets in different availability zones to allow workload distribution and will automatically re-schedule application pods to other AZ's if needed.
- Pod template is supplied with livenes- and readinessProbe to detect application failures and re-route traffic if pod is overloaded, providing fault-tolerance.

## Design decisions

- VPC created using [AWS VPC Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest). The module provides production-grade VPC configuration keeping the code simple and easy to read. The code from the repo will provide you with multiple internal and external subnets (3 of each) in different availability zones.
- EKS created using [AWS EKS Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) using EKS Auto mode. While tools like Minikube, MicroK8s takes less time to get an application running - they have little to no use in production-grade environments.\
EKS Auto comes with additional EKS addons configured out of the box, such as Karpenter and AWSLoadBalancerController, which are of good use in scope of the assignment. 

## CI/CD
- Build stage can be automated with CI tools such as Jenkins. Jenkins instance can be deployed in the same EKS cluster. There are numerous tools available to build OCI-compliant images inside of a container, such as Kaniko: https://github.com/GoogleContainerTools/kaniko
- ArgoCD or Flux can be used for deployment automation

## Things to improve
- kube-prometheus-stack must have its own Ingress configuration, which is supported in the chart (`$.values.ingress`) but takes time and effort to setup due to lack of hosted zone.
- Using EKS Terraform module with Managed node groups will provide fine controls over the node group configuration.
- Multiple Terraform modules share some variables which can be optimized by wrappers such as Terragrunt: https://terragrunt.gruntwork.io/
- Terraform backend can be moved over to an s3 bucket with addition of state locking through DynamoDB to make collaboration easier: https://developer.hashicorp.com/terraform/language/backend/s3
- Cert-manager can be added to the cluster to encrypt http traffic. SSL termination can be handled by ALB: https://cert-manager.io/docs/tutorials/getting-started-aws-letsencrypt/
- Keda can be added to provide event- and mertic-based scaling capabilities: https://keda.sh/
- External-secrets-operator can be added to allow retrieving and syncing secrets from AWS Secrets Manager: https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets
- Grafana Loki can be added to provide log aggregation: https://grafana.com/oss/loki/
- IAM permissions for applications to grant access rights to AWS recources can be supplied using IAM OIDC provider by linking ServiceAccounts to IAM roles: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html