{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sonarqube.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sonarqube.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "sonarqube.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate sonarqube certificate
*/}}
{{- define "sonarqube.sonarqube-certificate" }}
{{- if (not (empty .Values.ingress.sonarqube.certificate)) }}
{{- printf .Values.ingress.sonarqube.certificate }}
{{- else }}
{{- printf "%s-sonarqube-letsencrypt" (include "sonarqube.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "sonarqube.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "sonarqube.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate sonarqube hostname
*/}}
{{- define "sonarqube.sonarqube-hostname" }}
{{- if (and .Values.config.sonarqube.hostname (not (empty .Values.config.sonarqube.hostname))) }}
{{- printf .Values.config.sonarqube.hostname }}
{{- else }}
{{- if .Values.ingress.sonarqube.enabled }}
{{- printf .Values.ingress.sonarqube.hostname }}
{{- else }}
{{- printf "%s-sonarqube" (include "sonarqube.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate sonarqube base url
*/}}
{{- define "sonarqube.sonarqube-base-url" }}
{{- if (and .Values.config.sonarqube.baseUrl (not (empty .Values.config.sonarqube.baseUrl))) }}
{{- printf .Values.config.sonarqube.baseUrl }}
{{- else }}
{{- if .Values.ingress.sonarqube.enabled }}
{{- $hostname := ((empty (include "sonarqube.sonarqube-hostname" .)) | ternary .Values.ingress.sonarqube.hostname (include "sonarqube.sonarqube-hostname" .)) }}
{{- $path := (eq .Values.ingress.sonarqube.path "/" | ternary "" .Values.ingress.sonarqube.path) }}
{{- $protocol := (.Values.ingress.sonarqube.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "sonarqube.sonarqube-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "sonarqube.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "sonarqube.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}
