{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "postgres.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate postgres certificate
*/}}
{{- define "postgres.postgres-certificate" }}
{{- if (not (empty .Values.ingress.postgres.certificate)) }}
{{- printf .Values.ingress.postgres.certificate }}
{{- else }}
{{- printf "%s-postgres-letsencrypt" (include "postgres.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate postgres hostname
*/}}
{{- define "postgres.postgres-hostname" }}
{{- if (and .Values.config.postgres.hostname (not (empty .Values.config.postgres.hostname))) }}
{{- printf .Values.config.postgres.hostname }}
{{- else }}
{{- if .Values.ingress.postgres.enabled }}
{{- printf .Values.ingress.postgres.hostname }}
{{- else }}
{{- printf "%s-postgres" (include "postgres.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres base url
*/}}
{{- define "postgres.postgres-base-url" }}
{{- if (and .Values.config.postgres.baseUrl (not (empty .Values.config.postgres.baseUrl))) }}
{{- printf .Values.config.postgres.baseUrl }}
{{- else }}
{{- if .Values.ingress.postgres.enabled }}
{{- $hostname := ((empty (include "postgres.postgres-hostname" .)) | ternary .Values.ingress.postgres.hostname (include "postgres.postgres-hostname" .)) }}
{{- $protocol := (.Values.ingress.postgres.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "postgres.postgres-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
