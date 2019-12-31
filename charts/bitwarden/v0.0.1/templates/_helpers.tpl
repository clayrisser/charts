{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bitwarden.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "bitwarden.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "bitwarden.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate bitwardenrs certificate
*/}}
{{- define "bitwarden.bitwardenrs-certificate" }}
{{- if (not (empty .Values.ingress.bitwardenrs.certificate)) }}
{{- printf .Values.ingress.bitwardenrs.certificate }}
{{- else }}
{{- printf "%s-bitwardenrs-letsencrypt" (include "bitwarden.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate bitwardenrs hostname
*/}}
{{- define "bitwarden.bitwardenrs-hostname" }}
{{- if (and .Values.config.bitwardenrs.hostname (not (empty .Values.config.bitwardenrs.hostname))) }}
{{- printf .Values.config.bitwardenrs.hostname }}
{{- else }}
{{- if .Values.ingress.bitwardenrs.enabled }}
{{- printf .Values.ingress.bitwardenrs.hostname }}
{{- else }}
{{- printf "%s-bitwardenrs" (include "bitwarden.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate bitwardenrs base url
*/}}
{{- define "bitwarden.bitwardenrs-base-url" }}
{{- if (and .Values.config.bitwardenrs.baseUrl (not (empty .Values.config.bitwardenrs.baseUrl))) }}
{{- printf .Values.config.bitwardenrs.baseUrl }}
{{- else }}
{{- if .Values.ingress.bitwardenrs.enabled }}
{{- $hostname := ((empty (include "bitwarden.bitwardenrs-hostname" .)) | ternary .Values.ingress.bitwardenrs.hostname (include "bitwarden.bitwardenrs-hostname" .)) }}
{{- $path := (eq .Values.ingress.bitwardenrs.path "/" | ternary "" .Values.ingress.bitwardenrs.path) }}
{{- $protocol := (.Values.ingress.bitwardenrs.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "bitwarden.bitwardenrs-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
