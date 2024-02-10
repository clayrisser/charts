{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "keycloak.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "keycloak.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate keycloak certificate
*/}}
{{- define "keycloak.keycloak-certificate" -}}
{{- if .Values.ingress.keycloak.certificate -}}
{{- printf .Values.ingress.keycloak.certificate -}}
{{- else -}}
{{- printf "%s-discovery-letsencrypt" (include "keycloak.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate keycloak hostname
*/}}
{{- define "keycloak.keycloak-hostname" -}}
{{- if .Values.config.keycloak.hostname -}}
{{- printf .Values.config.keycloak.hostname -}}
{{- else -}}
{{- if .Values.ingress.keycloak.enabled -}}
{{- printf .Values.ingress.keycloak.hostname -}}
{{- else -}}
{{- printf "%s-discovery.%s.svc.cluster.local" (include "keycloak.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate keycloak base url
*/}}
{{- define "keycloak.keycloak-base-url" -}}
{{- if .Values.config.keycloak.baseUrl -}}
{{- printf .Values.config.keycloak.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.keycloak.enabled -}}
{{- $hostname := ((not (include "keycloak.keycloak-hostname" .)) | ternary .Values.ingress.keycloak.hostname (include "keycloak.keycloak-hostname" .)) -}}
{{- $protocol := (.Values.ingress.keycloak.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "keycloak.keycloak-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres url
*/}}
{{- define "keycloak.postgres-url" -}}
{{- $postgres := .Values.config.postgres -}}
{{- if $postgres.url -}}
{{- printf $postgres.url -}}
{{- else -}}
{{- $credentials := ((or (not $postgres.username) (not $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) -}}
{{- printf "postgresql://%s%s:%s/%s" $credentials $postgres.host ($postgres.port | toString) $postgres.database -}}
{{- end -}}
{{- end -}}

{{/*
Calculate ldap root dn
*/}}
{{- define "keycloak.ldap-root-dn" -}}
{{- if .Values.config.ldap.rootDN -}}
{{- if contains "." .Values.config.ldap.rootDN -}}
{{- printf "dc=%s,dc=%s" (index (regexSplit "\\." .Values.config.ldap.rootDN -1) 0) (index (regexSplit "\\." .Values.config.ldap.rootDN -1) 1) -}}
{{- else -}}
{{- printf "%s" .Values.config.ldap.rootDN -}}
{{- end -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate ldap certificate
*/}}
{{- define "keycloak.ldap-certificate" -}}
{{- if .Values.config.ldap.tls.certificate -}}
{{- printf "%s" .Values.config.ldap.tls.certificate -}}
{{- else -}}
{{- printf "ldap-cert" -}}
{{- end -}}
{{- end -}}

{{/*
Title case
*/}}
{{- define "titleCase" -}}
{{- print (upper (substr 0 1 .)) (substr 1 (len .) .) -}}
{{- end -}}
