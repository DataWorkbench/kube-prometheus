local mixin = import 'kube-prometheus/addons/config-mixins.libsonnet';
local custom_config = import './monitor_config.jsonnet';
local prom_pvc_config = import './prometheus-pvc.jsonnet';
local create_flink_service_monitor = import './flink-service-monitor.jsonnet';
local custom_ingress = import './custom-ingress.jsonnet';

// grafana DNS
local grafana_host = custom_config.grafana_host;
// alert manager DNS
local alert_manager_host = custom_config.alert_manager_host;
// prometheus dns
local prometheus_host = custom_config.prometheus_host;

local kp =
  (import 'kube-prometheus/main.libsonnet') +
  custom_ingress.custom_ingress(custom_config.prometheus_namespace, grafana_host, alert_manager_host, prometheus_host) +
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
        namespace: custom_config.prometheus_namespace,
      },
      prometheus+: {
        namespaces+: [custom_config.app_namespace],
      },
    },
    prometheus+:: prom_pvc_config.prometheus_pvc(custom_config.retention_time, custom_config.disk_size),
    customApplication: create_flink_service_monitor.flink_service_monitor(custom_config.app_namespace, custom_config.port_name),
  } + mixin.withImageRepository(custom_config.internal_registry);

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
