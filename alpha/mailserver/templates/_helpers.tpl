{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mailserver.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mailserver.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate rainloop certificate
*/}}
{{- define "mailserver.rainloop-certificate" }}
{{- if (not (empty .Values.ingress.rainloop.certificate)) }}
{{- printf .Values.ingress.rainloop.certificate }}
{{- else }}
{{- printf "%s-rainloop-letsencrypt" (include "mailserver.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate rainloop hostname
*/}}
{{- define "mailserver.rainloop-hostname" }}
{{- if (and .Values.config.rainloop.hostname (not (empty .Values.config.rainloop.hostname))) }}
{{- printf .Values.config.rainloop.hostname }}
{{- else }}
{{- if .Values.ingress.rainloop.enabled }}
{{- printf .Values.ingress.rainloop.hostname }}
{{- else }}
{{- printf "%s-rainloop" (include "mailserver.name" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate rainloop base url
*/}}
{{- define "mailserver.rainloop-base-url" }}
{{- if (and .Values.config.rainloop.baseUrl (not (empty .Values.config.rainloop.baseUrl))) }}
{{- printf .Values.config.rainloop.baseUrl }}
{{- else }}
{{- if .Values.ingress.rainloop.enabled }}
{{- $hostname := ((empty (include "mailserver.rainloop-hostname" .)) | ternary .Values.ingress.rainloop.hostname (include "mailserver.rainloop-hostname" .)) }}
{{- $protocol := (.Values.ingress.rainloop.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "mailserver.rainloop-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mailserver domain
*/}}
{{- define "mailserver.mailserver-domain" }}
{{- printf (.Values.config.domain | default (include "mailserver.rainloop-hostname" .)) }}
{{- end }}

{{/*
Calculate ldap dc
*/}}
{{- define "mailserver.ldap-dc" }}
{{- if .Values.config.ldap.domain }}
{{- $splitDomain := (regexSplit "\\." .Values.config.ldap.domain -1) }}
{{- printf "dc=%s,dc=%s" (index $splitDomain 0) (index $splitDomain 1) }}
{{- end }}
{{- end }}
