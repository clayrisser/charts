{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ejabberd.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "ejabberd.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate ejabberd certificate
*/}}
{{- define "ejabberd.ejabberd-certificate" }}
{{- if (not (empty .Values.ingress.ejabberd.certificate)) }}
{{- printf .Values.ingress.ejabberd.certificate }}
{{- else }}
{{- printf "%s-ejabberd-letsencrypt" (include "ejabberd.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "ejabberd.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "ejabberd.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpredisadmin certificate
*/}}
{{- define "ejabberd.phpredisadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpredisadmin.certificate)) }}
{{- printf .Values.ingress.phpredisadmin.certificate }}
{{- else }}
{{- printf "%s-phpredisadmin-letsencrypt" (include "ejabberd.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate ejabberd hostname
*/}}
{{- define "ejabberd.ejabberd-hostname" }}
{{- if (and .Values.config.ejabberd.hostname (not (empty .Values.config.ejabberd.hostname))) }}
{{- printf .Values.config.ejabberd.hostname }}
{{- else }}
{{- if .Values.ingress.ejabberd.enabled }}
{{- printf .Values.ingress.ejabberd.hostname }}
{{- else }}
{{- printf "%s-ejabberd" (include "ejabberd.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate ejabberd base url
*/}}
{{- define "ejabberd.ejabberd-base-url" }}
{{- if (and .Values.config.ejabberd.baseUrl (not (empty .Values.config.ejabberd.baseUrl))) }}
{{- printf .Values.config.ejabberd.baseUrl }}
{{- else }}
{{- if .Values.ingress.ejabberd.enabled }}
{{- $hostname := ((empty (include "ejabberd.ejabberd-hostname" .)) | ternary .Values.ingress.ejabberd.hostname (include "ejabberd.ejabberd-hostname" .)) }}
{{- $path := (eq .Values.ingress.ejabberd.path "/" | ternary "" .Values.ingress.ejabberd.path) }}
{{- $protocol := (.Values.ingress.ejabberd.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "ejabberd.ejabberd-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres host
*/}}
{{- define "ejabberd.postgres-host" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- printf "%s-postgres" (include "ejabberd.fullname" .) }}
{{- else }}
{{- printf "%s" $postgres.host }}
{{- end }}
{{- end }}

{{/*
Calculate redis host
*/}}
{{- define "ejabberd.redis-host" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- printf "%s-redis" (include "ejabberd.fullname" .) }}
{{- else }}
{{- printf "%s" $redis.host }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "ejabberd.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "ejabberd.fullname" .) $postgres.database }}
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
{{- define "ejabberd.redis-url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "ejabberd.fullname" .) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}
