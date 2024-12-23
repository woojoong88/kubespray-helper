# Dev note

## deploy cert-manager
```bash
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
$ helm install cert-manager jetstack/cert-manager  --namespace security-system --create-namespace --set crds.enabled=true
```

## deploy ingress-nginx
```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update
$ helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-system --create-namespace --set controller.service.type=NodePort --set controller.service.nodePorts.http=30080 --set controller.service.nodePorts.https=30443
```

## deploy Traefik proxy
```bash
$ helm repo add traefik https://traefik.github.io/charts
$ helm repo update
$ helm install traefik traefik/traefik -n ingress-proxy-system --create-namespace
```

## deploy Prometheus
```bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
$ helm repo update
$ helm upgrade -i prometheus prometheus-community/prometheus --namespace observability-system --create-namespace
```

## deploy Grafana
```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ helm install grafana grafana/grafana -n observability-system --create-namespace --set persistence.enabled=true
```

## deploy ELK stack
```bash
$ helm repo add elastic https://helm.elastic.co
$ helm repo update
$ helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
```