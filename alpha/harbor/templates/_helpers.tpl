{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "harbor.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "harbor.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate harbor certificate
*/}}
{{- define "harbor.harbor-certificate" }}
{{- if (not (empty .Values.ingress.harbor.certificate)) }}
{{- printf .Values.ingress.harbor.certificate }}
{{- else }}
{{- printf "%s-harbor-letsencrypt" (include "harbor.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate harbor hostname
*/}}
{{- define "harbor.harbor-hostname" }}
{{- if (and .Values.config.harbor.hostname (not (empty .Values.config.harbor.hostname))) }}
{{- printf .Values.config.harbor.hostname }}
{{- else }}
{{- if .Values.ingress.harbor.enabled }}
{{- printf .Values.ingress.harbor.hostname }}
{{- else }}
{{- printf "%s-harbor" (include "harbor.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate harbor base url
*/}}
{{- define "harbor.harbor-base-url" }}
{{- if (and .Values.config.harbor.baseUrl (not (empty .Values.config.harbor.baseUrl))) }}
{{- printf .Values.config.harbor.baseUrl }}
{{- else }}
{{- if .Values.ingress.harbor.enabled }}
{{- $hostname := ((empty (include "harbor.harbor-hostname" .)) | ternary .Values.ingress.harbor.hostname (include "harbor.harbor-hostname" .)) }}
{{- $protocol := (.Values.ingress.harbor.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "harbor.harbor-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "harbor.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
