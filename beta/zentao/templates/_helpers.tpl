{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "zentao.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "zentao.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate zentao certificate
*/}}
{{- define "zentao.zentao-certificate" -}}
{{- if .Values.ingress.zentao.certificate -}}
{{- printf .Values.ingress.zentao.certificate -}}
{{- else -}}
{{- printf "%s-discovery-letsencrypt" (include "zentao.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate zentao hostname
*/}}
{{- define "zentao.zentao-hostname" -}}
{{- if .Values.config.zentao.hostname -}}
{{- printf .Values.config.zentao.hostname -}}
{{- else -}}
{{- if .Values.ingress.zentao.enabled -}}
{{- printf .Values.ingress.zentao.hostname -}}
{{- else -}}
{{- printf "%s-discovery.%s.svc.cluster.local" (include "zentao.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate zentao base url
*/}}
{{- define "zentao.zentao-base-url" -}}
{{- if .Values.config.zentao.baseUrl -}}
{{- printf .Values.config.zentao.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.zentao.enabled -}}
{{- $hostname := ((not (include "zentao.zentao-hostname" .)) | ternary .Values.ingress.zentao.hostname (include "zentao.zentao-hostname" .)) -}}
{{- $protocol := (.Values.ingress.zentao.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "zentao.zentao-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate mysql url
*/}}
{{- define "zentao.mysql-url" -}}
{{- $mysql := .Values.config.mysql -}}
{{- if $mysql.url -}}
{{- printf $mysql.url -}}
{{- else -}}
{{- $credentials := ((or (not $mysql.username) (not $mysql.password)) | ternary "" (printf "%s:%s@" $mysql.username $mysql.password)) -}}
{{- printf "mysql://%s%s:%s/%s" $credentials $mysql.host ($mysql.port | toString) $mysql.database -}}
{{- end -}}
{{- end -}}
