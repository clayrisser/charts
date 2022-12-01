{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taiga.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "taiga.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate taiga certificate
*/}}
{{- define "taiga.taiga-certificate" -}}
{{- if .Values.service.taiga.tls.certificate.name -}}
{{- printf .Values.service.taiga.tls.certificate.name -}}
{{- else -}}
{{- printf "%s-cert" (include "taiga.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate taiga hostname
*/}}
{{- define "taiga.taiga-hostname" -}}
{{- if .Values.config.taiga.hostname -}}
{{- printf .Values.config.taiga.hostname -}}
{{- else -}}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Calculate taiga base url
*/}}
{{- define "taiga.taiga-base-url" -}}
{{- if .Values.config.taiga.baseUrl -}}
{{- printf .Values.config.taiga.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.taiga.enabled -}}
{{- $hostname := ((not (include "taiga.taiga-hostname" .)) | ternary .Values.ingress.taiga.hostname (include "taiga.taiga-hostname" .)) -}}
{{- $protocol := (.Values.ingress.taiga.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "taiga.taiga-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
