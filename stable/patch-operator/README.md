# patch-operator

> kubernetes operator that patches resources

**This project is deprecated in favor of [Kyverno](https://kyverno.io).**
Kyverno can do essentially everything this project set out to do
and much more.

## Migrate to Kyverno

The example _Kyverno Policy_ can achieve the same effect as a _Patch_.

_Kyverno Policy_

```yaml
apiVersion: kyverno.io/v1
kind: Policy
metadata:
  name: patch-hello-configmap
spec:
  background: true
  mutateExistingOnPolicyUpdate: true
  rules:
    - name: hello-configmap
      match:
        resources:
          kinds:
            - /*/ConfigMap
          names:
            - hello
      mutate:
        targets:
          - apiVersion: v1
            kind: ConfigMap
            name: hello
        patchStrategicMerge:
          data:
            hello: world
```

_Patch (Deprecated)_

```yaml
apiVersion: patch.rock8s.com/v1alpha1
kind: Patch
metadata:
  name: patch-hello-configmap
spec:
  patches:
    - id: hello-configmap
      target:
        apiVersion: v1
        kind: ConfigMap
        name: hello
      waitForResource: true
      type: merge
      patch: |
        data:
          hello: world
```

## Usage

### Recalibration

The patch will be recalibrated (forced to apply again) any time the
spec changes. It is a common practice to set the value of `spec.epoch`
to the current timestamp, thus forcing the patch to recalibrate every
time a deployment is updated.

### Install

```sh
helm repo add rock8s https://charts.rock8s.com
helm install patch-operator rock8s/patch-operator --version 0.1.0
```

You can learn more about this on [ArtifactHub](https://artifacthub.io/packages/helm/rock8s/patch-operator)

#### Example

Here's an example manifest file that creates a `Patch` resource.

```yaml
apiVersion: patch.rock8s.com/v1alpha1
kind: Patch
metadata:
  name: example-patch
spec:
  epoch: "2023"
  patches:
    - id: patch-1
      patch: |
        {
          "metadata": {
            "annotations": {
              "example.com/annotation": "true"
            }
          }
        }
      target:
        apiVersion: apps/v1
        kind: Deployment
        name: my-deployment
      type: "json"
      waitForResource: true
      waitForTimeout: 60000
    - id: patch-2
      patch: |
        [
          {
            "op": "replace",
            "path": "/spec/replicas",
            "value": 3
          }
        ]
      target:
        apiVersion: apps/v1
        kind: Deployment
        name: my-deployment
      type: "json"
```

### Properties

Here are the properties of a Patch resource:

- `epoch`
  A string value representing the epoch of the patch. This property can be used to force recalibration of resources.

- `image`
  A string value representing the name and tag of the image to be used in the job.
  The default image used is `registry.gitlab.com/bitspur/rock8s/images/kube-commands:3.18.0`.

- `patches`
  An array of patches to be applied. Each patch is defined by the following properties:
  - `id`: an optional string value representing the ID of the patch.
  - `patch`: a string value representing the patch to be applied.
  - `skipIf`: an optional array of criteria to skip the patch if met.
  - `target`: a set of properties that define the target resource to patch.
  - `type`: a string value representing the type of patch to apply (`json`, `merge`, `strategic` or `script`). You can read more about the different patch types [HERE](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/#use-a-json-merge-patch-to-update-a-deployment).
  - `waitForResource`: a boolean value representing whether to wait for the resource to exist before applying the patch.
  - `waitForTimeout`: an integer value representing the time in milliseconds to wait before applying the patch.
