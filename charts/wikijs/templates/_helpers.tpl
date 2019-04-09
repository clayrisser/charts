{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wikijs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wikijs.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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
{{- printf "%s://%s%s" $protocol $host.name $host.path }}
{{- else }}
{{- printf "http://%s-wikijs" (template "wikijs.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}
