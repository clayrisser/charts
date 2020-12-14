{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wordpress.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate wordpress certificate
*/}}
{{- define "wordpress.wordpress-certificate" }}
{{- if (not (empty .Values.ingress.wordpress.certificate)) }}
{{- printf .Values.ingress.wordpress.certificate }}
{{- else }}
{{- printf "%s-wordpress-letsencrypt" (include "wordpress.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate wordpress hostname
*/}}
{{- define "wordpress.wordpress-hostname" }}
{{- if (and .Values.config.wordpress.hostname (not (empty .Values.config.wordpress.hostname))) }}
{{- printf .Values.config.wordpress.hostname }}
{{- else }}
{{- if .Values.ingress.wordpress.enabled }}
{{- printf .Values.ingress.wordpress.hostname }}
{{- else }}
{{- printf "%s.%s.svc.cluster.local" (include "wordpress.fullname" .) .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate wordpress base url
*/}}
{{- define "wordpress.wordpress-base-url" }}
{{- if (and .Values.config.wordpress.baseUrl (not (empty .Values.config.wordpress.baseUrl))) }}
{{- printf .Values.config.wordpress.baseUrl }}
{{- else }}
{{- if .Values.ingress.wordpress.enabled }}
{{- $hostname := ((empty (include "wordpress.wordpress-hostname" .)) | ternary .Values.ingress.wordpress.hostname (include "wordpress.wordpress-hostname" .)) }}
{{- $protocol := (.Values.ingress.wordpress.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "wordpress.wordpress-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "wordpress.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- $credentials := ((or (empty $mysql.username) (empty $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) }}
{{- printf "jdbc:mysql://%s%s:%d/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
