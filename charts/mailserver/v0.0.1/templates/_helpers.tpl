{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mailserver.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mailserver.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate mailserver certificate
*/}}
{{- define "mailserver.mailserver-certificate" }}
{{- if (not (empty .Values.ingress.mailserver.certificate)) }}
{{- printf .Values.ingress.mailserver.certificate }}
{{- else }}
{{- printf "%s-mailserver-letsencrypt" (include "mailserver.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mailserver hostname
*/}}
{{- define "mailserver.mailserver-hostname" }}
{{- if (and .Values.config.mailserver.hostname (not (empty .Values.config.mailserver.hostname))) }}
{{- printf .Values.config.mailserver.hostname }}
{{- else }}
{{- if .Values.ingress.mailserver.enabled }}
{{- printf .Values.ingress.mailserver.hostname }}
{{- else }}
{{- printf "%s-mailserver" (include "mailserver.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mailserver base url
*/}}
{{- define "mailserver.mailserver-base-url" }}
{{- if (and .Values.config.mailserver.baseUrl (not (empty .Values.config.mailserver.baseUrl))) }}
{{- printf .Values.config.mailserver.baseUrl }}
{{- else }}
{{- if .Values.ingress.mailserver.enabled }}
{{- $hostname := ((empty (include "mailserver.mailserver-hostname" .)) | ternary .Values.ingress.mailserver.hostname (include "mailserver.mailserver-hostname" .)) }}
{{- $path := (eq .Values.ingress.mailserver.path "/" | ternary "" .Values.ingress.mailserver.path) }}
{{- $protocol := (.Values.ingress.mailserver.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "mailserver.mailserver-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
