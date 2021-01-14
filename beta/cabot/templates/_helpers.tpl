{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cabot.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "cabot.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate cabot certificate
*/}}
{{- define "cabot.cabot-certificate" }}
{{- if (not (empty .Values.ingress.cabot.certificate)) }}
{{- printf .Values.ingress.cabot.certificate }}
{{- else }}
{{- printf "%s-cabot-letsencrypt" (include "cabot.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate cabot hostname
*/}}
{{- define "cabot.cabot-hostname" }}
{{- if (and .Values.config.cabot.hostname (not (empty .Values.config.cabot.hostname))) }}
{{- printf .Values.config.cabot.hostname }}
{{- else }}
{{- if .Values.ingress.cabot.enabled }}
{{- printf .Values.ingress.cabot.hostname }}
{{- else }}
{{- printf "%s-cabot" (include "cabot.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate cabot base url
*/}}
{{- define "cabot.cabot-base-url" }}
{{- if (and .Values.config.cabot.baseUrl (not (empty .Values.config.cabot.baseUrl))) }}
{{- printf .Values.config.cabot.baseUrl }}
{{- else }}
{{- if .Values.ingress.cabot.enabled }}
{{- $hostname := ((empty (include "cabot.cabot-hostname" .)) | ternary .Values.ingress.cabot.hostname (include "cabot.cabot-hostname" .)) }}
{{- $protocol := (.Values.ingress.cabot.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "cabot.cabot-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "cabot.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgres://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}

{{/*
Calculate postgres storage name
*/}}
{{- define "cabot.postgres-storage" }}
{{ printf "%s%s" (include "cabot.fullname" .) ((empty .Values.config.postgres.integration) | ternary "" "-externaldb") }}
{{- end }}
