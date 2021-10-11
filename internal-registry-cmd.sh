docker pull quay.io/prometheus/alertmanager:v0.21.0
docker tag quay.io/prometheus/alertmanager:v0.21.0 dataworkbench/alertmanager:v0.21.0
docker push dataworkbench/alertmanager:v0.21.0
docker pull quay.io/prometheus/blackbox-exporter:v0.18.0
docker tag quay.io/prometheus/blackbox-exporter:v0.18.0 dataworkbench/blackbox-exporter:v0.18.0
docker push dataworkbench/blackbox-exporter:v0.18.0
docker pull grafana/grafana:7.5.4
docker tag grafana/grafana:7.5.4 dataworkbench/grafana:7.5.4
docker push dataworkbench/grafana:7.5.4
docker pull k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.0.0
docker tag k8s.gcr.io/kube-state-metrics/kube-state-metrics:v2.0.0 dataworkbench/kube-state-metrics:v2.0.0
docker push dataworkbench/kube-state-metrics:v2.0.0
docker pull quay.io/prometheus/node-exporter:v1.1.2
docker tag quay.io/prometheus/node-exporter:v1.1.2 dataworkbench/node-exporter:v1.1.2
docker push dataworkbench/node-exporter:v1.1.2
docker pull quay.io/prometheus/prometheus:v2.26.0
docker tag quay.io/prometheus/prometheus:v2.26.0 dataworkbench/prometheus:v2.26.0
docker push dataworkbench/prometheus:v2.26.0
docker pull directxman12/k8s-prometheus-adapter:v0.8.4
docker tag directxman12/k8s-prometheus-adapter:v0.8.4 dataworkbench/k8s-prometheus-adapter:v0.8.4
docker push dataworkbench/k8s-prometheus-adapter:v0.8.4
docker pull quay.io/prometheus-operator/prometheus-operator:v0.47.0
docker tag quay.io/prometheus-operator/prometheus-operator:v0.47.0 dataworkbench/prometheus-operator:v0.47.0
docker push dataworkbench/prometheus-operator:v0.47.0
docker pull quay.io/prometheus-operator/prometheus-config-reloader:v0.47.0
docker tag quay.io/prometheus-operator/prometheus-config-reloader:v0.47.0 dataworkbench/prometheus-config-reloader:v0.47.0
docker push dataworkbench/prometheus-config-reloader:v0.47.0
