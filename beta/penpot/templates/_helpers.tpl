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
{{- if (not (empty .Values.ingress.penpot.certificate)) }}
{{- printf .Values.ingress.penpot.certificate }}
{{- else }}
{{- printf "%s-release-letsencrypt" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Calculate penpot hostname
*/}}
{{- define "penpot.penpot-hostname" }}
{{- if (and .Values.config.frontend.hostname (not (empty .Values.config.frontend.hostname))) }}
{{- printf .Values.config.frontend.hostname }}
{{- else }}
{{- if .Values.ingress.penpot.enabled }}
{{- printf .Values.ingress.penpot.hostname }}
{{- else }}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate penpot base url
*/}}
{{- define "penpot.penpot-base-url" }}
{{- if (and .Values.config.frontend.baseUrl (not (empty .Values.config.frontend.baseUrl))) }}
{{- printf .Values.config.frontend.baseUrl }}
{{- else }}
{{- if .Values.ingress.penpot.enabled }}
{{- $hostname := ((empty (include "penpot.penpot-hostname" .)) | ternary .Values.ingress.penpot.hostname (include "penpot.penpot-hostname" .)) }}
{{- $protocol := (.Values.ingress.penpot.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "penpot.penpot-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
