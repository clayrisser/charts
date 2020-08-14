# stash-mongodb

[stash-mongodb](https://github.com/stashed/stash-mongodb) - MongoDB database backup/restore plugin for [Stash by AppsCode](https://appscode.com/products/stash/).

## TL;DR;

```console
helm repo add appscode https://charts.appscode.com/stable/
helm repo update
helm install appscode/stash-mongodb --name=stash-mongodb-3.4.17 --version=3.4.17
```

## Introduction

This chart installs necessary `Function` and `Task` definition to backup or restore MongoDB database 3.4.17 using Stash.

## Prerequisites

- Kubernetes 1.11+

## Installing the Chart

- Add AppsCode chart repository to your helm repository list,

```console
helm repo add appscode https://charts.appscode.com/stable/
```

- Update helm repositories to fetch latest charts from the remove repository,

```console
helm repo update
```

- Install the chart with the release name `stash-mongodb-3.4.17` run the following command,

```console
helm install appscode/stash-mongodb --name=stash-mongodb-3.4.17 --version=3.4.17
```

The above commands installs `Functions` and `Task` crds that are necessary to backup MongoDB database 3.4.17 using Stash.

## Uninstalling the Chart

To uninstall/delete the `stash-mongodb-3.4.17` run the following command,

```console
helm delete stash-mongodb-3.4.17
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the `stash-mongodb` chart and their default values.

| Parameter         | Description                                                                                                                   | Default         |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------- | --------------- |
| `docker.registry` | Docker registry used to pull respective images                                                                                | `stashed`       |
| `docker.image`    | Docker image used to backup/restore MongoDB database                                                                          | `stash-mongodb` |
| `docker.tag`      | Tag of the image that is used to backup/restore MongoDB database. This is usually same as the database version it can backup. | `3.4.17`        |
| `backup.mgArgs`   | Optional arguments to pass to `mongodump` command during bakcup process                                                       |                 |
| `restore.mgArgs`  | Optional arguments to pass to `mongorestore` command during restore process                                                   |                 |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

For example:

```console
helm install --name stash-mongodb-3.4.17 --set docker.registry=my-registry appscode/stash-mongodb
```
