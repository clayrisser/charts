{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openldap.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "openldap.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate openldap certificate
*/}}
{{- define "openldap.openldap-certificate" -}}
{{- if .Values.service.openldap.tls.certificate.name -}}
{{- printf .Values.service.openldap.tls.certificate.name -}}
{{- else -}}
{{- printf "%s-cert" (include "openldap.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate openldap ca
*/}}
{{- define "openldap.openldap-ca" -}}
{{- if .Values.service.openldap.tls.certificate.name -}}
{{- printf .Values.service.openldap.tls.certificate.ca -}}
{{- else -}}
{{- printf "ca" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate openldap hostname
*/}}
{{- define "openldap.openldap-hostname" -}}
{{- if .Values.config.openldap.hostname -}}
{{- printf .Values.config.openldap.hostname -}}
{{- else -}}
{{- printf "%s-release.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Calculate openldap dc
*/}}
{{- define "openldap.openldap-dc" -}}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.openldap.domain -1) 0) (index (regexSplit "\\." .Values.config.openldap.domain -1) 1) -}}
{{- end -}}

{{/*
Calculate phpldapadmin certificate
*/}}
{{- define "openldap.phpldapadmin-certificate" -}}
{{- if .Values.ingress.phpldapadmin.certificate -}}
{{- printf .Values.ingress.phpldapadmin.certificate -}}
{{- else -}}
{{- printf "%s-release-phpldapadmin-letsencrypt" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Calculate phpldapadmin hostname
*/}}
{{- define "openldap.phpldapadmin-hostname" -}}
{{- if .Values.config.phpldapadmin.hostname -}}
{{- printf .Values.config.phpldapadmin.hostname -}}
{{- else -}}
{{- if .Values.ingress.phpldapadmin.enabled -}}
{{- printf .Values.ingress.phpldapadmin.hostname -}}
{{- else -}}
{{- printf "%s-release-phpldapadmin.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate phpldapadmin base url
*/}}
{{- define "openldap.phpldapadmin-base-url" -}}
{{- if .Values.config.phpldapadmin.baseUrl -}}
{{- printf .Values.config.phpldapadmin.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.phpldapadmin.enabled -}}
{{- $hostname := ((not (include "openldap.phpldapadmin-hostname" .)) | ternary .Values.ingress.phpldapadmin.hostname (include "openldap.phpldapadmin-hostname" .)) -}}
{{- $protocol := (.Values.ingress.phpldapadmin.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "openldap.phpldapadmin-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
