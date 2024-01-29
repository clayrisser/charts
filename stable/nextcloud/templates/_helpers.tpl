{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "nextcloud.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate nextcloud certificate
*/}}
{{- define "nextcloud.nextcloud-certificate" -}}
{{- if .Values.ingress.nextcloud.certificate -}}
{{- printf .Values.ingress.nextcloud.certificate -}}
{{- else -}}
{{- printf "%s-gateway" (include "nextcloud.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate nextcloud hostname
*/}}
{{- define "nextcloud.nextcloud-hostname" -}}
{{- if .Values.config.nextcloud.hostname -}}
{{- printf .Values.config.nextcloud.hostname -}}
{{- else -}}
{{- if .Values.ingress.nextcloud.enabled -}}
{{- printf .Values.ingress.nextcloud.hostname -}}
{{- else -}}
{{- printf "%s-release-gateway.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate nextcloud base url
*/}}
{{- define "nextcloud.nextcloud-base-url" -}}
{{- if .Values.config.nextcloud.baseUrl -}}
{{- printf .Values.config.nextcloud.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.nextcloud.enabled -}}
{{- $hostname := ((not (include "nextcloud.nextcloud-hostname" .)) | ternary .Values.ingress.nextcloud.hostname (include "nextcloud.nextcloud-hostname" .)) -}}
{{- $protocol := (.Values.ingress.nextcloud.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "nextcloud.nextcloud-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate onlyoffice certificate
*/}}
{{- define "nextcloud.onlyoffice-certificate" -}}
{{- if .Values.ingress.onlyoffice.certificate -}}
{{- printf .Values.ingress.onlyoffice.certificate -}}
{{- else -}}
{{- printf "%s-gateway" (include "nextcloud.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate onlyoffice hostname
*/}}
{{- define "nextcloud.onlyoffice-hostname" -}}
{{- if .Values.config.onlyoffice.hostname -}}
{{- printf .Values.config.onlyoffice.hostname -}}
{{- else -}}
{{- if .Values.ingress.onlyoffice.enabled -}}
{{- printf .Values.ingress.onlyoffice.hostname -}}
{{- else -}}
{{- printf "%s-release-gateway.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate onlyoffice base url
*/}}
{{- define "nextcloud.onlyoffice-base-url" -}}
{{- if .Values.config.onlyoffice.baseUrl -}}
{{- printf .Values.config.onlyoffice.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.onlyoffice.enabled -}}
{{- $hostname := ((not (include "nextcloud.onlyoffice-hostname" .)) | ternary .Values.ingress.onlyoffice.hostname (include "nextcloud.onlyoffice-hostname" .)) -}}
{{- $protocol := (.Values.ingress.onlyoffice.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "nextcloud.onlyoffice-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pdfdraw certificate
*/}}
{{- define "nextcloud.pdfdraw-certificate" -}}
{{- if .Values.ingress.pdfdraw.certificate -}}
{{- printf .Values.ingress.pdfdraw.certificate -}}
{{- else -}}
{{- printf "%s-gateway" (include "nextcloud.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pdfdraw hostname
*/}}
{{- define "nextcloud.pdfdraw-hostname" -}}
{{- if .Values.config.pdfdraw.hostname -}}
{{- printf .Values.config.pdfdraw.hostname -}}
{{- else -}}
{{- if .Values.ingress.pdfdraw.enabled -}}
{{- printf .Values.ingress.pdfdraw.hostname -}}
{{- else -}}
{{- printf "%s-release-gateway.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pdfdraw base url
*/}}
{{- define "nextcloud.pdfdraw-base-url" -}}
{{- if .Values.config.pdfdraw.baseUrl -}}
{{- printf .Values.config.pdfdraw.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.pdfdraw.enabled -}}
{{- $hostname := ((not (include "nextcloud.pdfdraw-hostname" .)) | ternary .Values.ingress.pdfdraw.hostname (include "nextcloud.pdfdraw-hostname" .)) -}}
{{- $protocol := (.Values.ingress.pdfdraw.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "nextcloud.pdfdraw-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres url
*/}}
{{- define "nextcloud.postgres-url" -}}
{{- $postgres := .Values.config.postgres -}}
{{- if $postgres.url -}}
{{- printf $postgres.url -}}
{{- else -}}
{{- $credentials := ((or (not $postgres.username) (not $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) -}}
{{- printf "postgresql://%s%s:%s/%s" $credentials $postgres.host ($postgres.port | toString) $postgres.database -}}
{{- end -}}
{{- end -}}
