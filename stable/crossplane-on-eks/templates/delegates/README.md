# delegates

> crossplane delegate resources for aws

The delegates are crossplane resources that are used to delegate permissions safely across
a namespace boundary. For example, an `S3IRSA` could be created in the `s3` namespace
with a `DelegateS3IRSA` that delegates the permissions to the `nextcloud` namespace.

It works by creating an `AWSRole`, `AWSPolicy` and a `RolePolicyAttachment` that assumes the role
of a serviceaccount in the `nextcloud` namespace. The key part that makes this work is creating
the correct `AWSPolicy` with permission to access the s3 bucket from the `s3` namespace. In order
for this to work, the `bucketArn` of the `S3IRSA` in the `s3` namespace must be known.

We discover the `bucketArn` by creating a `ResourceBinding` to `S3IRSA` resource. A `ResourceBinding`
simply syncs properties from the bound resource to the status of the `ResourceBinding`. This exposes
the `status.bucketArn` from the `S3IRSA` resource to the `DelegateS3IRSA` resource through the
`status.resource.bucketArn` property of the `ResourceBinding` so crossplane is able to create the
correct `AWSPolicy`.

Keep in mind this entire process is still secure because the `DelegateS3IRSA` must be created in the
same namespace as the `S3IRSA`. It is simply delegating the permission to the `nextcloud` namespace.

More can be learned about the `ResourceBinding` resource at
[gitlab.com/bitspur/rock8s/resource-binding-operator](https://gitlab.com/bitspur/rock8s/resource-binding-operator).
