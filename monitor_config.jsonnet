{
  // the namespace in which the prometheus stack are deployed
  prometheus_namespace: 'dev',
  // the namespace in which the flink cluster are deployed
  app_namespace: 'my-flink',
  // flink metric service port name
  port_name: 'metrics',
  retention_time: '30d',
  // pvc disk size (default storageClass must exist in k8s cluster)
  disk_size: '50Gi',
  grafana_host: 'grafana.example.com',
  alert_manager_host: 'alertmanager.example.com',
  prometheus_host: 'prometheus.example.com',
  internal_registry: 'dataworkbench',
}