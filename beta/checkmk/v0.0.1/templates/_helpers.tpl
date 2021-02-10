{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "checkmk.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "checkmk.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate checkmk certificate
*/}}
{{- define "checkmk.checkmk-certificate" }}
{{- if (not (empty .Values.ingress.checkmk.certificate)) }}
{{- printf .Values.ingress.checkmk.certificate }}
{{- else }}
{{- printf "%s-checkmk-letsencrypt" (include "checkmk.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate checkmk hostname
*/}}
{{- define "checkmk.checkmk-hostname" }}
{{- if (and .Values.config.checkmk.hostname (not (empty .Values.config.checkmk.hostname))) }}
{{- printf .Values.config.checkmk.hostname }}
{{- else }}
{{- if .Values.ingress.checkmk.enabled }}
{{- printf .Values.ingress.checkmk.hostname }}
{{- else }}
{{- printf "%s-checkmk" (include "checkmk.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate checkmk base url
*/}}
{{- define "checkmk.checkmk-base-url" }}
{{- if (and .Values.config.checkmk.baseUrl (not (empty .Values.config.checkmk.baseUrl))) }}
{{- printf .Values.config.checkmk.baseUrl }}
{{- else }}
{{- if .Values.ingress.checkmk.enabled }}
{{- $hostname := ((empty (include "checkmk.checkmk-hostname" .)) | ternary .Values.ingress.checkmk.hostname (include "checkmk.checkmk-hostname" .)) }}
{{- $protocol := (.Values.ingress.checkmk.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "checkmk.checkmk-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
