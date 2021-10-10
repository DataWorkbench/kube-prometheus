{
  flink_service_monitor(app_namespace, port_name): {
    flinkJobManager: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'job-manager-monitor',
        namespace: app_namespace,
      },
      spec: {
        jobLabel: 'component',
        endpoints: [
          {
            port: port_name,
          },
        ],
        selector: {
          matchLabels: {
            component: 'jobmanager',
          },
        },
      },
    },
    flinkTaskManager: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'task-manager-monitor',
        namespace: app_namespace,
      },
      spec: {
        jobLabel: 'component',
        endpoints: [
          {
            port: port_name,
          },
        ],
        selector: {
          matchLabels: {
            component: 'taskmanager',
          },
        },
      },
    },
  },
}