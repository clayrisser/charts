# charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/risserlabs)](https://artifacthub.io/packages/search?repo=risserlabs)

> rock8s community helm charts

Please ★ this repo if you found it useful ★ ★ ★

## Guide

![](/assets//deployment-decision.jpg)

### Values Schema

```yaml
images:
  [name]:
    repository: some-repo
    tag: some-version

config:
  imagePullPolicy: IfNotPresent|Always
  updateStrategy: RollingUpdate|Recreate
  debug: false
  istio: false
  [name]:
    hostname: ''
    baseUrl: ''
    replicas: 1
    [...additionalConfig]
    resources:
      enabled: defaults
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 500m
        memory: 256Mi

services:
  [name]:
    type: ClusterIP|NodePort|LoadBalancer
    nodePorts:
      [protocolName]:
    lbPorts:
      [protocolName]: 80

ingresses:
  [name]:
    enabled: false
    hostname: ''
    tls:
      enabled: true
      certificate: ''
      issuer: ''

persistance:
  enabled: true
  size:
    [name]: 1Gi
  storageClass: ''
  velero:
    enabled: false
    restic: true
    schedule: '@midnight'
    ttl: 2160h0m00s
  kanister:
    enabled: false
    schedule: '0 0 * * *'
```

## License

[MIT License](/LICENSE)

[BitSpur](https://bitspur.com) © 2018-2023
