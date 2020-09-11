# stash-elasticserach

[stash-elasticsearch](https://github.com/stashed/stash-elasticsearch) - Elasticsearch database backup/restore plugin for [Stash by AppsCode](https://appscode.com/products/stash/).

## TL;DR;

```console
helm repo add appscode https://charts.appscode.com/stable/
helm repo update
helm install appscode/stash-elasticsearch --name=stash-elasticsearch-6.8 --version=6.8
```

## Introduction

This chart installs necessary `Function` and `Task` definition to backup or restore Elasticsearch database 6.8 using Stash.

## Prerequisites

- Kubernetes 1.11+

## Installing the Chart

- Add AppsCode chart repository to your helm repository list.

```console
helm repo add appscode https://charts.appscode.com/stable/
```

- Update helm repositories to fetch latest charts from the remove repository.

```console
helm repo update
```

- Install the chart with the release name `stash-elasticsearch-6.8` run the following command,

```console
helm install appscode/stash-elasticsearch --name=stash-elasticsearch-6.8 --version=6.8
```

The above commands installs `Functions` and `Task` crds that are necessary to backup Elasticsearch database 6.8 using Stash.

## Uninstalling the Chart

To uninstall/delete the `stash-elasticsearch-6.8` run the following command,

```console
helm delete stash-elasticsearch-6.8
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `stash-elasticsearch` chart and their default values.

| Parameter         | Description                                                                                                                         | Default               |
| ----------------- | :---------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `docker.registry` | Docker registry used to pull respective images                                                                                      | `stashed`             |
| `docker.image`    | Docker image used to backup/restore PosegreSQL database                                                                             | `stash-elasticsearch` |
| `docker.tag`      | Tag of the image that is used to backup/restore Elasticsearch database. This is usually same as the database version it can backup. | `6.8`                 |
| `backup.esArgs`   | Optional arguments to pass to `multielasticdump` command  during backup process                                                     |                       |
| `restore.esArgs`  | Optional arguments to pass to `multielasticdump` command during restore process                                                     |                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For example:

```console
helm install --name stash-elasticsearch-6.8 --set docker.registry=my-registry appscode/stash-elasticsearch
```
