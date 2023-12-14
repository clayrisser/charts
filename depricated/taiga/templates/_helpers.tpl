{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "taiga.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "taiga.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate taiga certificate
*/}}
{{- define "taiga.taiga-certificate" -}}
{{- if .Values.ingress.taiga.certificate -}}
{{- printf .Values.ingress.taiga.certificate -}}
{{- else -}}
{{- printf "%s-gateway" (include "taiga.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate taiga hostname
*/}}
{{- define "taiga.taiga-hostname" -}}
{{- if .Values.config.taiga.hostname -}}
{{- printf .Values.config.taiga.hostname -}}
{{- else -}}
{{- if .Values.ingress.taiga.enabled -}}
{{- printf .Values.ingress.taiga.hostname -}}
{{- else -}}
{{- printf "%s-release-gateway.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate taiga base url
*/}}
{{- define "taiga.taiga-base-url" -}}
{{- if .Values.config.taiga.baseUrl -}}
{{- printf .Values.config.taiga.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.taiga.enabled -}}
{{- $hostname := ((not (include "taiga.taiga-hostname" .)) | ternary .Values.ingress.taiga.hostname (include "taiga.taiga-hostname" .)) -}}
{{- $protocol := (.Values.ingress.taiga.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "taiga.taiga-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres url
*/}}
{{- define "taiga.postgres-url" -}}
{{- $postgres := .Values.config.postgres -}}
{{- if $postgres.url -}}
{{- printf $postgres.url -}}
{{- else -}}
{{- $credentials := ((or (not $postgres.username) (not $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) -}}
{{- printf "postgresql://%s%s:%s/%s" $credentials $postgres.host ($postgres.port | toString) $postgres.database -}}
{{- end -}}
{{- end -}}
