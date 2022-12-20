# charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/risserlabs)](https://artifacthub.io/packages/search?repo=risserlabs)

> risserlabs community helm charts

Please ★ this repo if you found it useful ★ ★ ★

## Guide

### Values Schema

```yaml
images:
  [name]:
    repository: some-repo
    tag: some-version

config:

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
    tls: true
    certificate: ''
    issuer:
      name: ''

persistance:
```

## License

[MIT License](/LICENSE)

[Risser Labs LLC](https://risserlabs.com) © 2018-2022
