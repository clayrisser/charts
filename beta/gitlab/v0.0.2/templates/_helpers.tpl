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
{{- $protocol := (.Values.ingress.gitlab.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
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
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}

{{/*
Calculate postgres storage name
*/}}
{{- define "gitlab.postgres-storage" }}
{{- printf "%s%s" (include "gitlab.fullname" .) ((empty .Values.config.postgres.integration) | ternary "" "-externaldb") }}
{{- end }}

{{/*
Calculate keycloak client id
*/}}
{{- define "gitlab.keycloak-client-id" }}
{{- printf "%s" (.Values.config.keycloak.clientId | default (include "gitlab.gitlab-hostname" .)) }}
{{- end }}
