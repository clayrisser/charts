{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sentry-tunnel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sentry-tunnel.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate sentry-tunnel certificate
*/}}
{{- define "sentry-tunnel.sentry-tunnel-certificate" -}}
{{- if .Values.ingress.sentryTunnel.certificate -}}
{{- printf .Values.ingress.sentryTunnel.certificate -}}
{{- else -}}
{{- printf "%s-discovery-letsencrypt" (include "sentry-tunnel.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate sentry-tunnel hostname
*/}}
{{- define "sentry-tunnel.sentry-tunnel-hostname" -}}
{{- if .Values.config.sentryTunnel.hostname -}}
{{- printf .Values.config.sentryTunnel.hostname -}}
{{- else -}}
{{- if .Values.ingress.sentryTunnel.enabled -}}
{{- printf .Values.ingress.sentryTunnel.hostname -}}
{{- else -}}
{{- printf "%s-discovery.%s.svc.cluster.local" (include "sentry-tunnel.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate sentry-tunnel base url
*/}}
{{- define "sentry-tunnel.sentry-tunnel-base-url" -}}
{{- if .Values.config.sentryTunnel.baseUrl -}}
{{- printf .Values.config.sentryTunnel.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.sentryTunnel.enabled -}}
{{- $hostname := ((not (include "sentry-tunnel.sentry-tunnel-hostname" .)) | ternary .Values.ingress.sentryTunnel.hostname (include "sentry-tunnel.sentry-tunnel-hostname" .)) -}}
{{- $protocol := (.Values.ingress.sentryTunnel.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "sentry-tunnel.sentry-tunnel-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
