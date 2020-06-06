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
Calculate ldap dc
*/}}
{{- define "mailserver.ldap-dc" }}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.ldap.domain -1) 0) (index (regexSplit "\\." .Values.config.ldap.domain -1) 1) }}
{{- end }}

{{/*
Calculate openldap dc
*/}}
{{- define "openldap.openldap-dc" }}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.domain -1) 0) (index (regexSplit "\\." .Values.config.domain -1) 1) }}
{{- end }}
