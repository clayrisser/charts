{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "penpot.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "penpot.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate penpot certificate
*/}}
{{- define "penpot.penpot-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-release-letsencrypt" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Calculate penpot hostname
*/}}
{{- define "penpot.penpot-hostname" }}
{{- if (and .Values.config.penpot.hostname (not (empty .Values.config.penpot.hostname))) }}
{{- printf .Values.config.penpot.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate penpot base url
*/}}
{{- define "penpot.penpot-base-url" }}
{{- if (and .Values.config.penpot.baseUrl (not (empty .Values.config.penpot.baseUrl))) }}
{{- printf .Values.config.penpot.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "penpot.penpot-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "penpot.penpot-hostname" .)) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "penpot.penpot-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
