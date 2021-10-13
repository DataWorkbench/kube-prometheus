local mixin = import 'kube-prometheus/addons/config-mixins.libsonnet';
// prometheus stack namespace
local prometheus_namespace = 'dev';
// the namespace in which the flink cluster are deployed
local app_namespace = 'my-flink';
// name of the port configured in values.yaml of flink helm
local port_name = 'metrics';
// monitor data retention time
local retention_time = '30d';
// pvc disk size
local disk_size = '50Gi';
local prom_pvc_config = import './prometheus-pvc.jsonnet';

local create_flink_service_monitor = import './flink-service-monitor.jsonnet';
local custom_ingress = import './custom-ingress.jsonnet';

// grafana DNS
local grafana_host = 'grafana.example.com';
// alert manager DNS
local alert_manager_host = 'alertmanager.example.com';
// prometheus dns
local prometheus_host = 'prometheus.example.com';

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  custom_ingress.custom_ingress(prometheus_namespace, grafana_host, alert_manager_host, prometheus_host) +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  {
    values+:: {
      common+: {
        namespace: prometheus_namespace,
      },
      prometheus+: {
        namespaces+: [app_namespace],
      },
    },
    prometheus+:: prom_pvc_config.prometheus_pvc(retention_time, disk_size),
    customApplication: create_flink_service_monitor.flink_service_monitor(app_namespace, port_name),
  } + mixin.withImageRepository('dataworkbench');

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ [name + '-ingress']: kp.ingress[name] for name in std.objectFields(kp.ingress) } +
{ ['flink-cluster-' + name]: kp.customApplication[name] for name in std.objectFields(kp.customApplication) }
