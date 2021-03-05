{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "erpnext.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "erpnext.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate erpnext certificate
*/}}
{{- define "erpnext.erpnext-certificate" }}
{{- if (not (empty .Values.ingress.erpnext.certificate)) }}
{{- printf .Values.ingress.erpnext.certificate }}
{{- else }}
{{- printf "%s-erpnext-letsencrypt" (include "erpnext.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate erpnext hostname
*/}}
{{- define "erpnext.erpnext-hostname" }}
{{- if (and .Values.config.erpnext.hostname (not (empty .Values.config.erpnext.hostname))) }}
{{- printf .Values.config.erpnext.hostname }}
{{- else }}
{{- if .Values.ingress.erpnext.enabled }}
{{- printf .Values.ingress.erpnext.hostname }}
{{- else }}
{{- printf "%s-erpnext" (include "erpnext.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate erpnext base url
*/}}
{{- define "erpnext.erpnext-base-url" }}
{{- if (and .Values.config.erpnext.baseUrl (not (empty .Values.config.erpnext.baseUrl))) }}
{{- printf .Values.config.erpnext.baseUrl }}
{{- else }}
{{- if .Values.ingress.erpnext.enabled }}
{{- $hostname := ((empty (include "erpnext.erpnext-hostname" .)) | ternary .Values.ingress.erpnext.hostname (include "erpnext.erpnext-hostname" .)) }}
{{- $protocol := (.Values.ingress.erpnext.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "erpnext.erpnext-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "erpnext.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
