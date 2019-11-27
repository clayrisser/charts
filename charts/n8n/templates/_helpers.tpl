{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "n8n.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "n8n.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "n8n.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate n8n certificate
*/}}
{{- define "n8n.n8n-certificate" }}
{{- if (not (empty .Values.ingress.n8n.certificate)) }}
{{- printf .Values.ingress.n8n.certificate }}
{{- else }}
{{- printf "%s-n8n-letsencrypt" (include "n8n.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate gatekeeper certificate
*/}}
{{- define "n8n.gatekeeper-certificate" }}
{{- if (not (empty .Values.ingress.gatekeeper.certificate)) }}
{{- printf .Values.ingress.gatekeeper.certificate }}
{{- else }}
{{- printf "%s-gatekeeper-letsencrypt" (include "n8n.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate n8n hostname
*/}}
{{- define "n8n.n8n-hostname" }}
{{- if (and .Values.config.n8n.hostname (not (empty .Values.config.n8n.hostname))) }}
{{- printf .Values.config.n8n.hostname }}
{{- else }}
{{- if .Values.ingress.n8n.enabled }}
{{- printf .Values.ingress.n8n.hostname }}
{{- else }}
{{- printf "%s-n8n" (include "n8n.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate n8n base url
*/}}
{{- define "n8n.n8n-base-url" }}
{{- if (and (not .Values.config.gatekeeper.enabled) (and .Values.config.baseUrl (not (empty .Values.config.baseUrl)))) }}
{{- printf .Values.config.baseUrl }}
{{- else if (and .Values.config.n8n.baseUrl (not (empty .Values.config.n8n.baseUrl))) }}
{{- printf .Values.config.n8n.baseUrl }}
{{- else }}
{{- if .Values.ingress.n8n.enabled }}
{{- $hostname := ((empty (include "n8n.n8n-hostname" .)) | ternary .Values.ingress.n8n.hostname (include "n8n.n8n-hostname" .)) }}
{{- $path := (eq .Values.ingress.n8n.path "/" | ternary "" .Values.ingress.n8n.path) }}
{{- $protocol := (.Values.ingress.n8n.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "n8n.n8n-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate gatekeeper hostname
*/}}
{{- define "n8n.gatekeeper-hostname" }}
{{- if (and .Values.config.gatekeeper.hostname (not (empty .Values.config.gatekeeper.hostname))) }}
{{- printf .Values.config.gatekeeper.hostname }}
{{- else }}
{{- if .Values.ingress.gatekeeper.enabled }}
{{- printf .Values.ingress.gatekeeper.hostname }}
{{- else }}
{{- printf "%s-gatekeeper" (include "n8n.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate gatekeeper base url
*/}}
{{- define "n8n.gatekeeper-base-url" }}
{{- if (and .Values.config.gatekeeper.enabled (and .Values.config.baseUrl (not (empty .Values.config.baseUrl)))) }}
{{- printf .Values.config.baseUrl }}
{{- else if (and .Values.config.gatekeeper.baseUrl (not (empty .Values.config.gatekeeper.baseUrl))) }}
{{- printf .Values.config.gatekeeper.baseUrl }}
{{- else }}
{{- if .Values.ingress.gatekeeper.enabled }}
{{- $hostname := ((empty (include "n8n.gatekeeper-hostname" .)) | ternary .Values.ingress.gatekeeper.hostname (include "n8n.gatekeeper-hostname" .)) }}
{{- $path := (eq .Values.ingress.gatekeeper.path "/" | ternary "" .Values.ingress.gatekeeper.path) }}
{{- $protocol := (.Values.ingress.gatekeeper.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "n8n.gatekeeper-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
