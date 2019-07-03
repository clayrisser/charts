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
Calculate hostname
*/}}
{{- define "gitlab.hostname" }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.gitlab 0).name }}
{{- else }}
{{- printf "%s-gitlab" (include "gitlab.fullname" . ) }}
{{- end }}
{{- end }}

{{/*
Calculate certificate
*/}}
{{- define "gitlab.certificate" }}
{{- if (not (empty .Values.ingress.certificate)) }}
{{- else }}
{{- printf "%s-letsencrypt" (include "gitlab.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "gitlab.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "gitlab.hostname" . )) | (index .Values.ingress.hosts.gitlab 0) (include "gitlab.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "gitlab.hostname" . )) }}
{{- printf "http://%s-gitlab" (include "gitlab.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "gitlab.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres_url
*/}}
{{- define "gitlab.postgres_url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "gitlab.fullname" . ) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
