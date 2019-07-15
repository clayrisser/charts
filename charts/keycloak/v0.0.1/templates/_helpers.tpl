{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "keycloak.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "keycloak.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.keycloak 0).name }}
{{- else }}
{{- printf "%s-keycloak" (include "keycloak.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate certificate
*/}}
{{- define "keycloak.certificate" }}
{{- if (not (empty .Values.ingress.certificate)) }}
{{- printf .Values.ingress.certificate }}
{{- else }}
{{- printf "%s-letsencrypt" (include "keycloak.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "keycloak.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "keycloak.hostname" . )) | (index .Values.ingress.hosts.keycloak 0) (include "keycloak.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "keycloak.hostname" . )) }}
{{- printf "http://%s-keycloak" (include "keycloak.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "keycloak.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres_url
*/}}
{{- define "keycloak.postgres_url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "keycloak.fullname" . ) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
