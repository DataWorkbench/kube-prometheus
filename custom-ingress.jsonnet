local fetch_url(dns, with_tail=false) =
  if with_tail then 'http://%s/' % [dns] else 'http://%s' % [dns];
local ingress(name, namespace, rules) = {
  apiVersion: 'networking.k8s.io/v1',
  kind: 'Ingress',
  metadata: {
    name: name,
    namespace: namespace,
  },
  spec: { rules: rules },
};

{
  custom_ingress(namespace, grafana_host, alert_manager_host, prometheus_host): {
    values+:: {
      grafana+:: {
        config+: {
          sections+: {
            server+: {
              root_url: fetch_url(grafana_host, true),
            },
          },
        },
      },
    },
    // Configure External URL's per application
    alertmanager+:: {
      alertmanager+: {
        spec+: {
          externalUrl: fetch_url(alert_manager_host),
        },
      },
    },
    prometheus+:: {
      prometheus+: {
        spec+: {
          externalUrl: fetch_url(prometheus_host),
        },
      },
    },
    // Create ingress objects per application
    ingress+:: {
      'alertmanager-main': ingress(
        'alertmanager-main',
        namespace,
        [{
          host: alert_manager_host,
          http: {
            paths: [{
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'alertmanager-main',
                  port: {
                    name: 'web',
                  },
                },
              },
            }],
          },
        }]
      ),
      grafana: ingress(
        'grafana',
        namespace,
        [{
          host: grafana_host,
          http: {
            paths: [{
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'grafana',
                  port: {
                    name: 'http',
                  },
                },
              },
            }],
          },
        }],
      ),
      'prometheus-k8s': ingress(
        'prometheus-k8s',
        namespace,
        [{
          host: prometheus_host,
          http: {
            paths: [{
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: 'prometheus-k8s',
                  port: {
                    name: 'web',
                  },
                },
              },
            }],
          },
        }],
      ),
    },
  },
}