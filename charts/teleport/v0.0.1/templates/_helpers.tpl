{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "teleport.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "teleport.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate hostname
*/}}
{{- define "teleport.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.teleport 0) }}
{{- else }}
{{- printf "%s-teleport" (include "teleport.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "teleport.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "teleport.hostname" . )) | (index .Values.ingress.hosts.teleport 0) (include "teleport.hostname" . ) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "teleport.hostname" . )) }}
{{- printf "http://%s-teleport" (include "teleport.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "teleport.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

