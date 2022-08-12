{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "minio.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "minio.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate minio certificate
*/}}
{{- define "minio.minio-certificate" -}}
{{- if .Values.ingress.minio.certificate -}}
{{- printf .Values.ingress.minio.certificate -}}
{{- else -}}
{{- printf "%s-minio-letsencrypt" (include "minio.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate minio hostname
*/}}
{{- define "minio.minio-hostname" -}}
{{- if .Values.config.minio.hostname -}}
{{- printf .Values.config.minio.hostname -}}
{{- else -}}
{{- if .Values.ingress.minio.enabled -}}
{{- printf .Values.ingress.minio.hostname -}}
{{- else -}}
{{- printf "%s-minio.%s.svc.cluster.local" (include "minio.fullname" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate minio base url
*/}}
{{- define "minio.minio-base-url" -}}
{{- if .Values.config.minio.baseUrl -}}
{{- printf .Values.config.minio.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.minio.enabled -}}
{{- $hostname := ((not (include "minio.minio-hostname" .)) | ternary .Values.ingress.minio.hostname (include "minio.minio-hostname" .)) -}}
{{- $protocol := (.Values.ingress.minio.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "minio.minio-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
