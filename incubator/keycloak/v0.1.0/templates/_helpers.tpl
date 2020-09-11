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
Calculate keycloak certificate
*/}}
{{- define "keycloak.keycloak-certificate" }}
{{- if (not (empty .Values.ingress.keycloak.certificate)) }}
{{- printf .Values.ingress.keycloak.certificate }}
{{- else }}
{{- printf "%s-keycloak-letsencrypt" (include "keycloak.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "keycloak.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "keycloak.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate keycloak hostname
*/}}
{{- define "keycloak.keycloak-hostname" }}
{{- if (and .Values.config.keycloak.hostname (not (empty .Values.config.keycloak.hostname))) }}
{{- printf .Values.config.keycloak.hostname }}
{{- else }}
{{- if .Values.ingress.keycloak.enabled }}
{{- printf .Values.ingress.keycloak.hostname }}
{{- else }}
{{- printf "%s-keycloak" (include "keycloak.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate keycloak base url
*/}}
{{- define "keycloak.keycloak-base-url" }}
{{- if (and .Values.config.keycloak.baseUrl (not (empty .Values.config.keycloak.baseUrl))) }}
{{- printf .Values.config.keycloak.baseUrl }}
{{- else }}
{{- if .Values.ingress.keycloak.enabled }}
{{- $hostname := ((empty (include "keycloak.keycloak-hostname" .)) | ternary .Values.ingress.keycloak.hostname (include "keycloak.keycloak-hostname" .)) }}
{{- $path := (eq .Values.ingress.keycloak.path "/" | ternary "" .Values.ingress.keycloak.path) }}
{{- $protocol := (.Values.ingress.keycloak.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "keycloak.keycloak-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "keycloak.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "keycloak.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
