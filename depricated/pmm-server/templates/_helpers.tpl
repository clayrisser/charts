{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pmm-server.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "pmm-server.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate pmm server certificate
*/}}
{{- define "pmm-server.pmm-server-certificate" }}
{{- if (not (empty .Values.ingress.pmmServer.certificate)) }}
{{- printf .Values.ingress.pmmServer.certificate }}
{{- else }}
{{- printf "%s-pmm-server-letsencrypt" (include "pmm-server.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pmm server hostname
*/}}
{{- define "pmm-server.pmm-server-hostname" }}
{{- if (and .Values.config.pmmServer.hostname (not (empty .Values.config.pmmServer.hostname))) }}
{{- printf .Values.config.pmmServer.hostname }}
{{- else }}
{{- if .Values.ingress.pmmServer.enabled }}
{{- printf .Values.ingress.pmmServer.hostname }}
{{- else }}
{{- printf "%s-pmm-server" (include "pmm-server.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate pmm server base url
*/}}
{{- define "pmm-server.pmm-server-base-url" }}
{{- if (and .Values.config.pmmServer.baseUrl (not (empty .Values.config.pmmServer.baseUrl))) }}
{{- printf .Values.config.pmmServer.baseUrl }}
{{- else }}
{{- if .Values.ingress.pmmServer.enabled }}
{{- $hostname := ((empty (include "pmm-server.pmm-server-hostname" .)) | ternary .Values.ingress.pmmServer.hostname (include "pmm-server.pmm-server-hostname" .)) }}
{{- $protocol := (.Values.ingress.pmmServer.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "pmm-server.pmm-server-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
