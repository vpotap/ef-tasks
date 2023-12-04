resource "kubernetes_manifest" "multi_container_secret" {
  manifest = yamldecode(file("manifests/multi-container-secret.yml"))
}

resource "kubernetes_manifest" "multi_container_deployment" {
  manifest = yamldecode(file("manifests/multi-container.yml"))
}
