{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "erpnext.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "erpnext.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate erpnext certificate
*/}}
{{- define "erpnext.erpnext-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-release-letsencrypt" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Calculate erpnext hostname
*/}}
{{- define "erpnext.erpnext-hostname" }}
{{- if (and .Values.config.erpnext.hostname (not (empty .Values.config.erpnext.hostname))) }}
{{- printf .Values.config.erpnext.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate erpnext base url
*/}}
{{- define "erpnext.erpnext-base-url" }}
{{- if (and .Values.config.erpnext.baseUrl (not (empty .Values.config.erpnext.baseUrl))) }}
{{- printf .Values.config.erpnext.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "erpnext.erpnext-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "erpnext.erpnext-hostname" .)) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "erpnext.erpnext-hostname" .) }}
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
