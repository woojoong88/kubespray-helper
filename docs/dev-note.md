# Dev note

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