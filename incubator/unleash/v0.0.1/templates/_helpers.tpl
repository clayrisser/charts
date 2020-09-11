{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "unleash.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "unleash.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "unleash.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.unleash 0).name }}
{{- else }}
{{- printf "%s-unleash" (include "unleash.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "unleash.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "unleash.hostname" . )) | (index .Values.ingress.hosts.unleash 0) (include "unleash.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "unleash.hostname" . )) }}
{{- printf "http://%s-unleash" (include "unleash.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "unleash.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres_url
*/}}
{{- define "unleash.postgres_url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "unleash.fullname" . ) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
