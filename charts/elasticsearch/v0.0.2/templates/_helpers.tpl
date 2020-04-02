{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "elasticsearch.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate elasticsearch certificate
*/}}
{{- define "elasticsearch.elasticsearch-certificate" }}
{{- if (not (empty .Values.ingress.elasticsearch.certificate)) }}
{{- printf .Values.ingress.elasticsearch.certificate }}
{{- else }}
{{- printf "%s-elasticsearch-letsencrypt" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate elasticsearch hostname
*/}}
{{- define "elasticsearch.elasticsearch-hostname" }}
{{- if (and .Values.config.hostname (not (empty .Values.config.hostname))) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.elasticsearch.enabled }}
{{- printf .Values.ingress.elasticsearch.hostname }}
{{- else }}
{{- printf "%s-elasticsearch" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate elasticsearch base url
*/}}
{{- define "elasticsearch.elasticsearch-base-url" }}
{{- if (and .Values.config.baseUrl (not (empty .Values.config.baseUrl))) }}
{{- printf .Values.config.baseUrl }}
{{- else }}
{{- if .Values.ingress.elasticsearch.enabled }}
{{- $hostname := ((empty (include "elasticsearch.elasticsearch-hostname" .)) | ternary .Values.ingress.elasticsearch.hostname (include "elasticsearch.elasticsearch-hostname" .)) }}
{{- $path := (eq .Values.ingress.elasticsearch.path "/" | ternary "" .Values.ingress.elasticsearch.path) }}
{{- $protocol := (.Values.ingress.elasticsearch.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "elasticsearch.elasticsearch-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate kibana certificate
*/}}
{{- define "elasticsearch.kibana-certificate" }}
{{- if (not (empty .Values.ingress.kibana.certificate)) }}
{{- printf .Values.ingress.kibana.certificate }}
{{- else }}
{{- printf "%s-kibana-letsencrypt" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate kibana hostname
*/}}
{{- define "elasticsearch.kibana-hostname" }}
{{- if (and .Values.config.hostname (not (empty .Values.config.hostname))) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.elasticsearch.enabled }}
{{- printf .Values.ingress.elasticsearch.hostname }}
{{- else }}
{{- printf "%s-kibana" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate kibana base url
*/}}
{{- define "elasticsearch.kibana-base-url" }}
{{- if (and .Values.config.baseUrl (not (empty .Values.config.baseUrl))) }}
{{- printf .Values.config.baseUrl }}
{{- else }}
{{- if .Values.ingress.elasticsearch.enabled }}
{{- $hostname := ((empty (include "elasticsearch.kibana-hostname" .)) | ternary .Values.ingress.elasticsearch.hostname (include "elasticsearch.kibana-hostname" .)) }}
{{- $path := (eq .Values.ingress.elasticsearch.path "/" | ternary "" .Values.ingress.elasticsearch.path) }}
{{- $protocol := (.Values.ingress.elasticsearch.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "elasticsearch.kibana-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
