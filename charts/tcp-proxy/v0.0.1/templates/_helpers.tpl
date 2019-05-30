{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tcp-proxy.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "tcp-proxy.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "tcp-proxy.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.tcp-proxy 0).name }}
{{- else }}
{{- printf "%s-tcp-proxy" (include "tcp-proxy.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "tcp-proxy.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "tcp-proxy.hostname" . )) | (index .Values.ingress.hosts.tcp-proxy 0) (include "tcp-proxy.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "tcp-proxy.hostname" . )) }}
{{- printf "http://%s-tcp-proxy" (include "tcp-proxy.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "tcp-proxy.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

