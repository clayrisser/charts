{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sentry.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sentry.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "sentry.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}

{{/*
Calculate sentry certificate
*/}}
{{- define "sentry.sentry-certificate" }}
{{- if (not (empty .Values.ingress.sentry.certificate)) }}
{{- printf .Values.ingress.sentry.certificate }}
{{- else }}
{{- printf "%s-sentry-letsencrypt" (include "sentry.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate sentry hostname
*/}}
{{- define "sentry.sentry-hostname" }}
{{- if (and .Values.config.sentry.hostname (not (empty .Values.config.sentry.hostname))) }}
{{- printf .Values.config.sentry.hostname }}
{{- else }}
{{- if .Values.ingress.sentry.enabled }}
{{- printf .Values.ingress.sentry.hostname }}
{{- else }}
{{- printf "%s-sentry" (include "sentry.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate sentry base url
*/}}
{{- define "sentry.sentry-base-url" }}
{{- if (and .Values.config.sentry.baseUrl (not (empty .Values.config.sentry.baseUrl))) }}
{{- printf .Values.config.sentry.baseUrl }}
{{- else }}
{{- if .Values.ingress.sentry.enabled }}
{{- $hostname := ((empty (include "sentry.sentry-hostname" .)) | ternary .Values.ingress.sentry.hostname (include "sentry.sentry-hostname" .)) }}
{{- $protocol := (.Values.ingress.sentry.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "sentry.sentry-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
