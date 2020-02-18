{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "nextcloud.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "nextcloud.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate nextcloud certificate
*/}}
{{- define "nextcloud.nextcloud-certificate" }}
{{- if (not (empty .Values.ingress.nextcloud.certificate)) }}
{{- printf .Values.ingress.nextcloud.certificate }}
{{- else }}
{{- printf "%s-nextcloud-letsencrypt" (include "nextcloud.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "nextcloud.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "nextcloud.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate nextcloud hostname
*/}}
{{- define "nextcloud.nextcloud-hostname" }}
{{- if (and .Values.config.nextcloud.hostname (not (empty .Values.config.nextcloud.hostname))) }}
{{- printf .Values.config.nextcloud.hostname }}
{{- else }}
{{- if .Values.ingress.nextcloud.enabled }}
{{- printf .Values.ingress.nextcloud.hostname }}
{{- else }}
{{- printf "%s-nextcloud" (include "nextcloud.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate nextcloud base url
*/}}
{{- define "nextcloud.nextcloud-base-url" }}
{{- if (and .Values.config.nextcloud.baseUrl (not (empty .Values.config.nextcloud.baseUrl))) }}
{{- printf .Values.config.nextcloud.baseUrl }}
{{- else }}
{{- if .Values.ingress.nextcloud.enabled }}
{{- $hostname := ((empty (include "nextcloud.nextcloud-hostname" .)) | ternary .Values.ingress.nextcloud.hostname (include "nextcloud.nextcloud-hostname" .)) }}
{{- $path := (eq .Values.ingress.nextcloud.path "/" | ternary "" .Values.ingress.nextcloud.path) }}
{{- $protocol := (.Values.ingress.nextcloud.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "nextcloud.nextcloud-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "nextcloud.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "nextcloud.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
