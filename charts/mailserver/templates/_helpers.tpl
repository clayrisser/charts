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
{{- if (and .Values.config.hostname (not (empty .Values.config.hostname))) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.rainloop.enabled }}
{{- printf .Values.ingress.rainloop.hostname }}
{{- else }}
{{- printf "%s-rainloop" (include "mailserver.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate ldap dc
*/}}
{{- define "mailserver.ldap-dc" }}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.ldap.domain -1) 0) (index (regexSplit "\\." .Values.config.ldap.domain -1) 1) }}
{{- end }}
