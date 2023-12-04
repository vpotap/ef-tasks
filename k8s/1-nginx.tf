# create custom ns if needed
#resource "kubernetes_namespace" "stage" {
#    metadata {
#        name = "stage"
#    }
#}

resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(file("manifests/nginx-deployment.yml"))
}

resource "kubernetes_manifest" "nginx_service" {
  manifest = yamldecode(file("manifests/nginx-service.yml"))
}

resource "kubernetes_manifest" "nginx_hpa_v1" {
  manifest = yamldecode(file("manifests/nginx-hpa-v1.yml"))
}