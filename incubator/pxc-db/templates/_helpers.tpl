{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pxc-db.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "pxc-db.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate mysql certificate
*/}}
{{- define "pxc-db.mysql-certificate" }}
{{- if (not (empty .Values.ingress.mysql.certificate)) }}
{{- printf .Values.ingress.mysql.certificate }}
{{- else }}
{{- printf "%s-mysql-letsencrypt" (include "pxc-db.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mysql hostname
*/}}
{{- define "pxc-db.mysql-hostname" }}
{{- if (and .Values.config.mysql.hostname (not (empty .Values.config.mysql.hostname))) }}
{{- printf .Values.config.mysql.hostname }}
{{- else }}
{{- if .Values.ingress.mysql.enabled }}
{{- printf .Values.ingress.mysql.hostname }}
{{- else }}
{{- printf "%s-mysql" (include "pxc-db.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql base url
*/}}
{{- define "pxc-db.mysql-base-url" }}
{{- if (and .Values.config.mysql.baseUrl (not (empty .Values.config.mysql.baseUrl))) }}
{{- printf .Values.config.mysql.baseUrl }}
{{- else }}
{{- if .Values.ingress.mysql.enabled }}
{{- $hostname := ((empty (include "pxc-db.mysql-hostname" .)) | ternary .Values.ingress.mysql.hostname (include "pxc-db.mysql-hostname" .)) }}
{{- $protocol := (.Values.ingress.mysql.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "pxc-db.mysql-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "pxc-db.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- $credentials := ((or (empty $mysql.username) (empty $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) }}
{{- printf "jdbc:mysql://%s%s:%s/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
