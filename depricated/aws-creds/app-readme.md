# aws-creds

> provides aws credentials for an ack resources

For security purposes, the ack resource must exist in the
same namespace as the plug and must be in a healthy state.
In other words, the ack resource must have `status.ackResourceMetadata.arn`.
