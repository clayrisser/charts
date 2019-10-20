{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "flectra.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "flectra.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "flectra.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate flectra certificate
*/}}
{{- define "flectra.flectra-certificate" }}
{{- if (not (empty .Values.ingress.flectra.certificate)) }}
{{- printf .Values.ingress.flectra.certificate }}
{{- else }}
{{- printf "%s-flectra-letsencrypt" (include "flectra.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "flectra.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "flectra.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate flectra hostname
*/}}
{{- define "flectra.flectra-hostname" }}
{{- if (and .Values.config.flectra.hostname (not (empty .Values.config.flectra.hostname))) }}
{{- printf .Values.config.flectra.hostname }}
{{- else }}
{{- if .Values.ingress.flectra.enabled }}
{{- printf .Values.ingress.flectra.hostname }}
{{- else }}
{{- printf "%s-flectra" (include "flectra.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate flectra base url
*/}}
{{- define "flectra.flectra-base-url" }}
{{- if (and .Values.config.flectra.baseUrl (not (empty .Values.config.flectra.baseUrl))) }}
{{- printf .Values.config.flectra.baseUrl }}
{{- else }}
{{- if .Values.ingress.flectra.enabled }}
{{- $hostname := ((empty (include "flectra.flectra-hostname" .)) | ternary .Values.ingress.flectra.hostname (include "flectra.flectra-hostname" .)) }}
{{- $path := (eq .Values.ingress.flectra.path "/" | ternary "" .Values.ingress.flectra.path) }}
{{- $protocol := (.Values.ingress.flectra.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "flectra.flectra-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "flectra.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "flectra.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
