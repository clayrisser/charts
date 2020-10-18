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
Calculate openldap dc
*/}}
{{- define "openldap.openldap-dc" }}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.domain -1) 0) (index (regexSplit "\\." .Values.config.domain -1) 1) }}
{{- end }}

{{/*
Calculate openldap hostname
*/}}
{{- define "openldap.openldap-hostname" }}
{{- if (and .Values.config.openldap.hostname (not (empty .Values.config.openldap.hostname))) }}
{{- printf .Values.config.openldap.hostname }}
{{- else }}
{{- printf "%s-openldap" (include "openldap.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpldapadmin certificate
*/}}
{{- define "openldap.phpldapadming-certificate" }}
{{- if (not (empty .Values.ingress.phpldapadmin.certificate)) }}
{{- printf .Values.ingress.phpldapadmin.certificate }}
{{- else }}
{{- printf "%s-phpldapadming-letsencrypt" (include "openldap.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpldapadmin hostname
*/}}
{{- define "openldap.phpldapadming-hostname" }}
{{- if (and .Values.config.phpldapadmin.hostname (not (empty .Values.config.phpldapadmin.hostname))) }}
{{- printf .Values.config.phpldapadmin.hostname }}
{{- else }}
{{- if .Values.ingress.phpldapadmin.enabled }}
{{- printf .Values.ingress.phpldapadmin.hostname }}
{{- else }}
{{- printf "%s-openldap" (include "openldap.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate phpldapadmin base url
*/}}
{{- define "openldap.phpldapadming-base-url" }}
{{- if (and .Values.config.phpldapadmin.baseUrl (not (empty .Values.config.phpldapadmin.baseUrl))) }}
{{- printf .Values.config.phpldapadmin.baseUrl }}
{{- else }}
{{- if .Values.ingress.phpldapadmin.enabled }}
{{- $hostname := ((empty (include "openldap.phpldapadming-hostname" .)) | ternary .Values.ingress.phpldapadmin.hostname (include "openldap.phpldapadming-hostname" .)) }}
{{- $protocol := (.Values.ingress.phpldapadmin.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "openldap.phpldapadming-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
