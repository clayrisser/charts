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
Calculate pgadmin certificate
*/}}
{{- define "postgres.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.postgres.certificate)) }}
{{- printf .Values.ingress.postgres.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "postgres.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin hostname
*/}}
{{- define "postgres.pgadmin-hostname" }}
{{- if (and .Values.config.postgres.hostname (not (empty .Values.config.postgres.hostname))) }}
{{- printf .Values.config.postgres.hostname }}
{{- else }}
{{- if .Values.ingress.postgres.enabled }}
{{- printf .Values.ingress.postgres.hostname }}
{{- else }}
{{- printf "%s-pgadmin" (include "postgres.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin base url
*/}}
{{- define "postgres.pgadmin-base-url" }}
{{- if (and .Values.config.postgres.baseUrl (not (empty .Values.config.postgres.baseUrl))) }}
{{- printf .Values.config.postgres.baseUrl }}
{{- else }}
{{- if .Values.ingress.postgres.enabled }}
{{- $hostname := ((empty (include "postgres.pgadmin-hostname" .)) | ternary .Values.ingress.postgres.hostname (include "postgres.pgadmin-hostname" .)) }}
{{- $protocol := (.Values.ingress.postgres.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "postgres.pgadmin-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Grafana datasource name
*/}}
{{- define "postgres.grafana-datasource" }}
{{- printf "%s-prometheus-%s" (include "postgres.fullname" .) .Release.Namespace }}
{{- end }}
