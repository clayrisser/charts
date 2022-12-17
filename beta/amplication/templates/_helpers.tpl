{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "amplication.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "amplication.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate amplication certificate
*/}}
{{- define "amplication.amplication-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-release-letsencrypt" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Calculate amplication hostname
*/}}
{{- define "amplication.amplication-hostname" }}
{{- if (and .Values.config.amplication.hostname (not (empty .Values.config.amplication.hostname))) }}
{{- printf .Values.config.amplication.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate amplication base url
*/}}
{{- define "amplication.amplication-base-url" }}
{{- if (and .Values.config.amplication.baseUrl (not (empty .Values.config.amplication.baseUrl))) }}
{{- printf .Values.config.amplication.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "amplication.amplication-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "amplication.amplication-hostname" .)) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "amplication.amplication-hostname" .) }}
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
