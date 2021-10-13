{
  prometheus_pvc(retention_time, disk_size): {
    prometheus+: {
      spec+: {
        retention: retention_time,
        storage: {
          volumeClaimTemplate: {
            apiVersion: 'v1',
            kind: 'PersistentVolumeClaim',
            spec: {
              accessModes: ['ReadWriteOnce'],
              resources: { requests: { storage: disk_size } },
            },
          },
        },
      },
    },
  },
}