{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "grafana.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "grafana.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate grafana certificate
*/}}
{{- define "grafana.grafana-certificate" }}
{{- if (not (empty .Values.ingress.grafana.certificate)) }}
{{- printf .Values.ingress.grafana.certificate }}
{{- else }}
{{- printf "%s-grafana-letsencrypt" (include "grafana.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate grafana hostname
*/}}
{{- define "grafana.grafana-hostname" }}
{{- if (and .Values.config.grafana.hostname (not (empty .Values.config.grafana.hostname))) }}
{{- printf .Values.config.grafana.hostname }}
{{- else }}
{{- if .Values.ingress.grafana.enabled }}
{{- printf .Values.ingress.grafana.hostname }}
{{- else }}
{{- printf "%s-grafana" (include "grafana.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate grafana base url
*/}}
{{- define "grafana.grafana-base-url" }}
{{- if (and .Values.config.grafana.baseUrl (not (empty .Values.config.grafana.baseUrl))) }}
{{- printf .Values.config.grafana.baseUrl }}
{{- else }}
{{- if .Values.ingress.grafana.enabled }}
{{- $hostname := ((empty (include "grafana.grafana-hostname" .)) | ternary .Values.ingress.grafana.hostname (include "grafana.grafana-hostname" .)) }}
{{- $protocol := (.Values.ingress.grafana.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "grafana.grafana-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
