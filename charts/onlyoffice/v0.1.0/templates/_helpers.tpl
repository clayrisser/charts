{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "onlyoffice.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "onlyoffice.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "onlyoffice.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate onlyoffice certificate
*/}}
{{- define "onlyoffice.onlyoffice-certificate" }}
{{- if (not (empty .Values.ingress.onlyoffice.certificate)) }}
{{- printf .Values.ingress.onlyoffice.certificate }}
{{- else }}
{{- printf "%s-onlyoffice-letsencrypt" (include "onlyoffice.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "onlyoffice.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "onlyoffice.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpredisadmin certificate
*/}}
{{- define "onlyoffice.phpredisadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpredisadmin.certificate)) }}
{{- printf .Values.ingress.phpredisadmin.certificate }}
{{- else }}
{{- printf "%s-phpredisadmin-letsencrypt" (include "onlyoffice.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate onlyoffice hostname
*/}}
{{- define "onlyoffice.onlyoffice-hostname" }}
{{- if (and .Values.config.onlyoffice.hostname (not (empty .Values.config.onlyoffice.hostname))) }}
{{- printf .Values.config.onlyoffice.hostname }}
{{- else }}
{{- if .Values.ingress.onlyoffice.enabled }}
{{- printf .Values.ingress.onlyoffice.hostname }}
{{- else }}
{{- printf "%s-onlyoffice" (include "onlyoffice.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate onlyoffice base url
*/}}
{{- define "onlyoffice.onlyoffice-base-url" }}
{{- if (and .Values.config.onlyoffice.baseUrl (not (empty .Values.config.onlyoffice.baseUrl))) }}
{{- printf .Values.config.onlyoffice.baseUrl }}
{{- else }}
{{- if .Values.ingress.onlyoffice.enabled }}
{{- $hostname := ((empty (include "onlyoffice.onlyoffice-hostname" .)) | ternary .Values.ingress.onlyoffice.hostname (include "onlyoffice.onlyoffice-hostname" .)) }}
{{- $path := (eq .Values.ingress.onlyoffice.path "/" | ternary "" .Values.ingress.onlyoffice.path) }}
{{- $protocol := (.Values.ingress.onlyoffice.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "onlyoffice.onlyoffice-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "onlyoffice.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "onlyoffice.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate redis url
*/}}
{{- define "onlyoffice.redis-url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "onlyoffice.fullname" .) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}
