resource "helm_release" "zookeeper" {
  name       = "zookeeper"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "zookeeper"
  version    = "12.1.0"

  set {
    name  = "replicaCount"
    value = "3"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.storageClass"
    value = "standard" # use default minikube sc
  }

  set {
    name  = "persistence.accessMode"
    value = "ReadWriteOnce"
  }

  set {
    name  = "persistence.size"
    value = "1Gi"  # overwrite default 8gb
  }

  set {
    name  = "persistence.dataLogDir.size"
    value = "1Gi"  # overwrite default 8gb
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"  # overwrite default 256Mi
  }  

   set {
    name  = "resources.requests.cpu"
    value = "250m"  # 250m
  }  
}