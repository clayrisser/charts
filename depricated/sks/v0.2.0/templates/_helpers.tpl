{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sks.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sks.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sks.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate sks certificate
*/}}
{{- define "sks.sks-certificate" }}
{{- if (not (empty .Values.ingress.sks.certificate)) }}
{{- printf .Values.ingress.sks.certificate }}
{{- else }}
{{- printf "%s-sks-letsencrypt" (include "sks.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate sks hostname
*/}}
{{- define "sks.sks-hostname" }}
{{- if (and .Values.config.sks.hostname (not (empty .Values.config.sks.hostname))) }}
{{- printf .Values.config.sks.hostname }}
{{- else }}
{{- if .Values.ingress.sks.enabled }}
{{- printf .Values.ingress.sks.hostname }}
{{- else }}
{{- printf "%s-sks" (include "sks.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate sks base url
*/}}
{{- define "sks.sks-base-url" }}
{{- if (and .Values.config.sks.baseUrl (not (empty .Values.config.sks.baseUrl))) }}
{{- printf .Values.config.sks.baseUrl }}
{{- else }}
{{- if .Values.ingress.sks.enabled }}
{{- $hostname := ((empty (include "sks.sks-hostname" .)) | ternary .Values.ingress.sks.hostname (include "sks.sks-hostname" .)) }}
{{- $path := (eq .Values.ingress.sks.path "/" | ternary "" .Values.ingress.sks.path) }}
{{- $protocol := (.Values.ingress.sks.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "sks.sks-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
