{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wikijs.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wikijs.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wikijs.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate wiki certificate
*/}}
{{- define "wikijs.wiki-certificate" }}
{{- if (not (empty .Values.ingress.wiki.certificate)) }}
{{- printf .Values.ingress.wiki.certificate }}
{{- else }}
{{- printf "%s-wiki-letsencrypt" (include "wikijs.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "wikijs.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "wikijs.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate wiki hostname
*/}}
{{- define "wikijs.wiki-hostname" }}
{{- if (and .Values.config.wiki.hostname (not (empty .Values.config.wiki.hostname))) }}
{{- printf .Values.config.wiki.hostname }}
{{- else }}
{{- if .Values.ingress.wiki.enabled }}
{{- printf .Values.ingress.wiki.hostname }}
{{- else }}
{{- printf "%s-wiki" (include "wikijs.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate wiki base url
*/}}
{{- define "wikijs.wiki-base-url" }}
{{- if (and .Values.config.wiki.baseUrl (not (empty .Values.config.wiki.baseUrl))) }}
{{- printf .Values.config.wiki.baseUrl }}
{{- else }}
{{- if .Values.ingress.wiki.enabled }}
{{- $hostname := ((empty (include "wikijs.wiki-hostname" .)) | ternary .Values.ingress.wiki.hostname (include "wikijs.wiki-hostname" .)) }}
{{- $path := (eq .Values.ingress.wiki.path "/" | ternary "" .Values.ingress.wiki.path) }}
{{- $protocol := (.Values.ingress.wiki.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "wikijs.wiki-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "wikijs.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "wikijs.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
