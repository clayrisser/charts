{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openldap.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "openldap.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate openldap certificate
*/}}
{{- define "openldap.openldap-certificate" }}
{{- if (not (empty .Values.ingress.openldap.certificate)) }}
{{- printf .Values.ingress.openldap.certificate }}
{{- else }}
{{- printf "%s-openldap-letsencrypt" (include "openldap.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate openldap hostname
*/}}
{{- define "openldap.openldap-hostname" }}
{{- if (and .Values.config.openldap.hostname (not (empty .Values.config.openldap.hostname))) }}
{{- printf .Values.config.openldap.hostname }}
{{- else }}
{{- if .Values.ingress.openldap.enabled }}
{{- printf .Values.ingress.openldap.hostname }}
{{- else }}
{{- printf "%s.%s.svc.cluster.local" (include "openldap.fullname" .) .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate openldap base url
*/}}
{{- define "openldap.openldap-base-url" }}
{{- if (and .Values.config.openldap.baseUrl (not (empty .Values.config.openldap.baseUrl))) }}
{{- printf .Values.config.openldap.baseUrl }}
{{- else }}
{{- if .Values.ingress.openldap.enabled }}
{{- $hostname := ((empty (include "openldap.openldap-hostname" .)) | ternary .Values.ingress.openldap.hostname (include "openldap.openldap-hostname" .)) }}
{{- $protocol := (.Values.ingress.openldap.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "openldap.openldap-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "openldap.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- $credentials := ((or (empty $mysql.username) (empty $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) }}
{{- printf "jdbc:mysql://%s%s:%d/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
