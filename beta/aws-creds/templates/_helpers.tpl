{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "aws-creds.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "aws-creds.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "aws-creds.cluster-name" -}}
{{- $clusterInfo := lookup "v1" "ConfigMap" "rock8s-global" "cluster-info" }}
{{- if (and $clusterInfo $clusterInfo.data) -}}
{{- $clusterInfo.data.clusterName | default "local" -}}
{{- end -}}
{{- end -}}
