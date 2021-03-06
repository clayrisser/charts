{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bitwardenrs.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "bitwardenrs.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate bitwardenrs certificate
*/}}
{{- define "bitwardenrs.bitwardenrs-certificate" }}
{{- if (not (empty .Values.ingress.bitwardenrs.certificate)) }}
{{- printf .Values.ingress.bitwardenrs.certificate }}
{{- else }}
{{- printf "%s-bitwardenrs-letsencrypt" (include "bitwardenrs.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate bitwardenrs hostname
*/}}
{{- define "bitwardenrs.bitwardenrs-hostname" }}
{{- if (and .Values.config.bitwardenrs.hostname (not (empty .Values.config.bitwardenrs.hostname))) }}
{{- printf .Values.config.bitwardenrs.hostname }}
{{- else }}
{{- if .Values.ingress.bitwardenrs.enabled }}
{{- printf .Values.ingress.bitwardenrs.hostname }}
{{- else }}
{{- printf "%s-bitwardenrs" (include "bitwardenrs.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate bitwardenrs base url
*/}}
{{- define "bitwardenrs.bitwardenrs-base-url" }}
{{- if (and .Values.config.bitwardenrs.baseUrl (not (empty .Values.config.bitwardenrs.baseUrl))) }}
{{- printf .Values.config.bitwardenrs.baseUrl }}
{{- else }}
{{- if .Values.ingress.bitwardenrs.enabled }}
{{- $hostname := ((empty (include "bitwardenrs.bitwardenrs-hostname" .)) | ternary .Values.ingress.bitwardenrs.hostname (include "bitwardenrs.bitwardenrs-hostname" .)) }}
{{- $protocol := (.Values.ingress.bitwardenrs.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "bitwardenrs.bitwardenrs-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "bitwardenrs.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
