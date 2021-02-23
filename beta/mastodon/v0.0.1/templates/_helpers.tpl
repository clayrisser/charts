{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mastodon.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate mastodon certificate
*/}}
{{- define "mastodon.mastodon-certificate" }}
{{- if (not (empty .Values.ingress.mastodon.certificate)) }}
{{- printf .Values.ingress.mastodon.certificate }}
{{- else }}
{{- printf "%s-mastodon-letsencrypt" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mastodon hostname
*/}}
{{- define "mastodon.mastodon-hostname" }}
{{- if (and .Values.config.mastodon.hostname (not (empty .Values.config.mastodon.hostname))) }}
{{- printf .Values.config.mastodon.hostname }}
{{- else }}
{{- if .Values.ingress.mastodon.enabled }}
{{- printf .Values.ingress.mastodon.hostname }}
{{- else }}
{{- printf "%s-mastodon" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mastodon base url
*/}}
{{- define "mastodon.mastodon-base-url" }}
{{- if (and .Values.config.mastodon.baseUrl (not (empty .Values.config.mastodon.baseUrl))) }}
{{- printf .Values.config.mastodon.baseUrl }}
{{- else }}
{{- if .Values.ingress.mastodon.enabled }}
{{- $hostname := ((empty (include "mastodon.mastodon-hostname" .)) | ternary .Values.ingress.mastodon.hostname (include "mastodon.mastodon-hostname" .)) }}
{{- $protocol := (.Values.ingress.mastodon.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "mastodon.mastodon-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "mastodon.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- $credentials := ((or (empty $postgres.username) (empty $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) }}
{{- printf "postgresql://%s%s:%d/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
