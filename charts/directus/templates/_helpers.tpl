{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "directus.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "directus.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate directus certificate
*/}}
{{- define "directus.directus-certificate" }}
{{- if (not (empty .Values.ingress.directus.certificate)) }}
{{- printf .Values.ingress.directus.certificate }}
{{- else }}
{{- printf "%s-directus-letsencrypt" (include "directus.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpmyadmin certificate
*/}}
{{- define "directus.phpmyadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpmyadmin.certificate)) }}
{{- printf .Values.ingress.phpmyadmin.certificate }}
{{- else }}
{{- printf "%s-phpmyadmin-letsencrypt" (include "directus.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate directus hostname
*/}}
{{- define "directus.directus-hostname" }}
{{- if (and .Values.config.directus.hostname (not (empty .Values.config.directus.hostname))) }}
{{- printf .Values.config.directus.hostname }}
{{- else }}
{{- if .Values.ingress.directus.enabled }}
{{- printf .Values.ingress.directus.hostname }}
{{- else }}
{{- printf "%s-directus" (include "directus.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate directus base url
*/}}
{{- define "directus.directus-base-url" }}
{{- if (and .Values.config.directus.baseUrl (not (empty .Values.config.directus.baseUrl))) }}
{{- printf .Values.config.directus.baseUrl }}
{{- else }}
{{- if .Values.ingress.directus.enabled }}
{{- $hostname := ((empty (include "directus.directus-hostname" .)) | ternary .Values.ingress.directus.hostname (include "directus.directus-hostname" .)) }}
{{- $path := (eq .Values.ingress.directus.path "/" | ternary "" .Values.ingress.directus.path) }}
{{- $protocol := (.Values.ingress.directus.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "directus.directus-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "directus.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.internal }}
{{- $credentials := (printf "%s:%s" $mysql.username $mysql.password) }}
{{- printf "jdbc:mysql://%s@%s-mysql:3306/%s" $credentials (include "directus.fullname" .) $mysql.database }}
{{- else }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- printf "jdbc:mysql://%s@%s:%s/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
{{- end }}
