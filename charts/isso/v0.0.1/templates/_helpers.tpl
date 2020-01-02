{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "isso.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "isso.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "isso.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate isso certificate
*/}}
{{- define "isso.isso-certificate" }}
{{- if (not (empty .Values.ingress.isso.certificate)) }}
{{- printf .Values.ingress.isso.certificate }}
{{- else }}
{{- printf "%s-isso-letsencrypt" (include "isso.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate isso hostname
*/}}
{{- define "isso.isso-hostname" }}
{{- if (and .Values.config.isso.hostname (not (empty .Values.config.isso.hostname))) }}
{{- printf .Values.config.isso.hostname }}
{{- else }}
{{- if .Values.ingress.isso.enabled }}
{{- printf .Values.ingress.isso.hostname }}
{{- else }}
{{- printf "%s-isso" (include "isso.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate isso base url
*/}}
{{- define "isso.isso-base-url" }}
{{- if (and .Values.config.isso.baseUrl (not (empty .Values.config.isso.baseUrl))) }}
{{- printf .Values.config.isso.baseUrl }}
{{- else }}
{{- if .Values.ingress.isso.enabled }}
{{- $hostname := ((empty (include "isso.isso-hostname" .)) | ternary .Values.ingress.isso.hostname (include "isso.isso-hostname" .)) }}
{{- $path := (eq .Values.ingress.isso.path "/" | ternary "" .Values.ingress.isso.path) }}
{{- $protocol := (.Values.ingress.isso.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "isso.isso-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
