{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nginx.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "nginx.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate nginx certificate
*/}}
{{- define "nginx.nginx-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-nginx-letsencrypt" (include "nginx.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate nginx hostname
*/}}
{{- define "nginx.nginx-hostname" }}
{{- if (and .Values.config.nginx.hostname (not (empty .Values.config.nginx.hostname))) }}
{{- printf .Values.config.nginx.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-nginx" (include "nginx.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate nginx base url
*/}}
{{- define "nginx.nginx-base-url" }}
{{- if (and .Values.config.nginx.baseUrl (not (empty .Values.config.nginx.baseUrl))) }}
{{- printf .Values.config.nginx.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "nginx.nginx-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "nginx.nginx-hostname" .)) }}
{{- $path := (eq .Values.ingress.nginx.path "/" | ternary "" .Values.ingress.nginx.path) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "nginx.nginx-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
