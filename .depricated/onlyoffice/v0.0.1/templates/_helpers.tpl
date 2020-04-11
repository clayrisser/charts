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
Calculate base_url
*/}}
{{- define "onlyoffice.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.onlyoffice 0) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-onlyoffice" (include "onlyoffice.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres_url
*/}}
{{- define "onlyoffice.postgres_url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "onlyoffice.fullname" . ) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
{{/*
Calculate redis_url
*/}}
{{- define "onlyoffice.redis_url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "onlyoffice.fullname" . ) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}
