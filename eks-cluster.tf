module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name = local.cluster_name
  cluster_version = "1.27"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size = 1
      max_size = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size = 1
      max_size = 2
      desired_size = 1
    }
  }
}
# Provision Weaviate on EKS
resource "kubectl_manifest" "weaviate" {
  depends_on = [module.eks]
  manifest = <<EOF
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: weaviate
  namespace: default
spec:
  releaseName: weaviate
  chart:
    repository: https://github.com/semi-technologies/weaviate-helm
    name: weaviate
    version: 0.23.0 # Change this to the desired version
    # Add other necessary configurations like values, etc.
EOF
