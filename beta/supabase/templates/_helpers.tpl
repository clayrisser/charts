{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "supabase.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "supabase.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate supabase certificate
*/}}
{{- define "supabase.supabase-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-release-letsencrypt" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Calculate supabase hostname
*/}}
{{- define "supabase.supabase-hostname" }}
{{- if (and .Values.config.supabase.hostname (not (empty .Values.config.supabase.hostname))) }}
{{- printf .Values.config.supabase.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate supabase base url
*/}}
{{- define "supabase.supabase-base-url" }}
{{- if (and .Values.config.supabase.baseUrl (not (empty .Values.config.supabase.baseUrl))) }}
{{- printf .Values.config.supabase.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "supabase.supabase-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "supabase.supabase-hostname" .)) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "supabase.supabase-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "keycloak.mysql-url" -}}
{{- $mysql := .Values.config.mysql -}}
{{- if $mysql.url -}}
{{- printf $mysql.url -}}
{{- else -}}
{{- $credentials := ((or (not $mysql.username) (not $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) -}}
{{- printf "mysql://%s%s:%s/%s" $credentials $mysql.host ($mysql.port | toString) $mysql.database -}}
{{- end -}}
{{- end -}}
