{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "s3.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "s3.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "s3.cluster-name" -}}
{{- $clusterEnvironment := lookup "v1" "ConfigMap" "global" "cluster-environment" }}
{{- if (and $clusterEnvironment $clusterEnvironment.data) -}}
{{- $clusterEnvironment.data.clusterName | default "local" -}}
{{- else -}}
{{- "cluster.local" -}}
{{- end -}}
{{- end -}}

{{- define "s3.aws-region" -}}
{{- $clusterEnvironment := lookup "v1" "ConfigMap" "global" "cluster-environment" }}
{{- if (and $clusterEnvironment $clusterEnvironment.data) -}}
{{- $clusterEnvironment.data.awsRegion | default "us-east-1" -}}
{{- else -}}
{{- "us-east-1" -}}
{{- end -}}
{{- end -}}
