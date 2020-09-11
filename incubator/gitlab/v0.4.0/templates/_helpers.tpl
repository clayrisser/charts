{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitlab.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "gitlab.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate gitlab certificate
*/}}
{{- define "gitlab.gitlab-certificate" }}
{{- if (not (empty .Values.ingress.gitlab.certificate)) }}
{{- printf .Values.ingress.gitlab.certificate }}
{{- else }}
{{- printf "%s-gitlab-letsencrypt" (include "gitlab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "gitlab.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "gitlab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpredisadmin certificate
*/}}
{{- define "gitlab.phpredisadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpredisadmin.certificate)) }}
{{- printf .Values.ingress.phpredisadmin.certificate }}
{{- else }}
{{- printf "%s-phpredisadmin-letsencrypt" (include "gitlab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate gitlab hostname
*/}}
{{- define "gitlab.gitlab-hostname" }}
{{- if (and .Values.config.gitlab.hostname (not (empty .Values.config.gitlab.hostname))) }}
{{- printf .Values.config.gitlab.hostname }}
{{- else }}
{{- if .Values.ingress.gitlab.enabled }}
{{- printf .Values.ingress.gitlab.hostname }}
{{- else }}
{{- printf "%s-gitlab" (include "gitlab.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate gitlab base url
*/}}
{{- define "gitlab.gitlab-base-url" }}
{{- if (and .Values.config.gitlab.baseUrl (not (empty .Values.config.gitlab.baseUrl))) }}
{{- printf .Values.config.gitlab.baseUrl }}
{{- else }}
{{- if .Values.ingress.gitlab.enabled }}
{{- $hostname := ((empty (include "gitlab.gitlab-hostname" .)) | ternary .Values.ingress.gitlab.hostname (include "gitlab.gitlab-hostname" .)) }}
{{- $path := (eq .Values.ingress.gitlab.path "/" | ternary "" .Values.ingress.gitlab.path) }}
{{- $protocol := (.Values.ingress.gitlab.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "gitlab.gitlab-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "gitlab.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "gitlab.fullname" .) $postgres.database }}
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
{{- define "gitlab.redis-url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "gitlab.fullname" .) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}
