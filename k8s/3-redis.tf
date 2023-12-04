resource "kubernetes_manifest" "redis_configmap" {
  manifest = yamldecode(file("manifests/redis-configmap.yml"))
}

resource "kubernetes_manifest" "redis_deployment" {
  manifest = yamldecode(file("manifests/redis-deployment.yml"))
}

resource "kubernetes_manifest" "redis_service" {
  manifest = yamldecode(file("manifests/redis-service.yml"))
}