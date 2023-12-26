# Provision Weaviate on EKS
resource "kubectl_manifest" "weaviate" {
  depends_on = [module.eks_cluster]
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
