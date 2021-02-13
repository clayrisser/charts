{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "drupal.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "drupal.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate drupal certificate
*/}}
{{- define "drupal.drupal-certificate" }}
{{- if (not (empty .Values.ingress.drupal.certificate)) }}
{{- printf .Values.ingress.drupal.certificate }}
{{- else }}
{{- printf "%s-drupal-letsencrypt" (include "drupal.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate drupal hostname
*/}}
{{- define "drupal.drupal-hostname" }}
{{- if (and .Values.config.drupal.hostname (not (empty .Values.config.drupal.hostname))) }}
{{- printf .Values.config.drupal.hostname }}
{{- else }}
{{- if .Values.ingress.drupal.enabled }}
{{- printf .Values.ingress.drupal.hostname }}
{{- else }}
{{- printf "%s.%s.svc.cluster.local" (include "drupal.fullname" .) .Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate drupal base url
*/}}
{{- define "drupal.drupal-base-url" }}
{{- if (and .Values.config.drupal.baseUrl (not (empty .Values.config.drupal.baseUrl))) }}
{{- printf .Values.config.drupal.baseUrl }}
{{- else }}
{{- if .Values.ingress.drupal.enabled }}
{{- $hostname := ((empty (include "drupal.drupal-hostname" .)) | ternary .Values.ingress.drupal.hostname (include "drupal.drupal-hostname" .)) }}
{{- $protocol := (.Values.ingress.drupal.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "drupal.drupal-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "drupal.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- $credentials := ((or (empty $mysql.username) (empty $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) }}
{{- printf "jdbc:mysql://%s%s:%d/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
