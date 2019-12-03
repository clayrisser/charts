{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sourcegraph.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sourcegraph.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sourcegraph.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate sourcegraph certificate
*/}}
{{- define "sourcegraph.sourcegraph-certificate" }}
{{- if (not (empty .Values.ingress.sourcegraph.certificate)) }}
{{- printf .Values.ingress.sourcegraph.certificate }}
{{- else }}
{{- printf "%s-sourcegraph-letsencrypt" (include "sourcegraph.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate sourcegraph hostname
*/}}
{{- define "sourcegraph.sourcegraph-hostname" }}
{{- if (and .Values.config.sourcegraph.hostname (not (empty .Values.config.sourcegraph.hostname))) }}
{{- printf .Values.config.sourcegraph.hostname }}
{{- else }}
{{- if .Values.ingress.sourcegraph.enabled }}
{{- printf .Values.ingress.sourcegraph.hostname }}
{{- else }}
{{- printf "%s-sourcegraph" (include "sourcegraph.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate sourcegraph base url
*/}}
{{- define "sourcegraph.sourcegraph-base-url" }}
{{- if (and .Values.config.sourcegraph.baseUrl (not (empty .Values.config.sourcegraph.baseUrl))) }}
{{- printf .Values.config.sourcegraph.baseUrl }}
{{- else }}
{{- if .Values.ingress.sourcegraph.enabled }}
{{- $hostname := ((empty (include "sourcegraph.sourcegraph-hostname" .)) | ternary .Values.ingress.sourcegraph.hostname (include "sourcegraph.sourcegraph-hostname" .)) }}
{{- $path := (eq .Values.ingress.sourcegraph.path "/" | ternary "" .Values.ingress.sourcegraph.path) }}
{{- $protocol := (.Values.ingress.sourcegraph.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "sourcegraph.sourcegraph-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
