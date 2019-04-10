{{- $name := default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- $fullname := printf "%s-%s" .Release.Name (default .Chart.Name .Values.nameOverride) | trunc 63 | trimSuffix "-" }}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wikijs.name" }}
{{- $name }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wikijs.fullname" }}
{{- printf $fullname }}
{{- end -}}

{{/*
Calculate base_url
*/}}
{{- define "wikijs.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.wikijs 0) }}
{{- $protocol := "http" }}
{{- if .Values.ingress.tls }}
{{- $protocol := (printf "%ss" $protocol) }}
{{- end }}
{{- $path := "" }}
{{- if (not (eq $host.path "/")) }}
{{- $path := $host.path }}
{{- end }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-wikijs" $fullname }}
{{- end }}
{{- end }}
{{- end }}
