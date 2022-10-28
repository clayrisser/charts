{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "postgres.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate postgres certificate
*/}}
{{- define "postgres.postgres-certificate" -}}
{{- if .Values.service.postgres.tls.certificate.name -}}
{{- printf .Values.service.postgres.tls.certificate.name -}}
{{- else -}}
{{- printf "%s-cert" (include "postgres.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres ca
*/}}
{{- define "postgres.postgres-ca" -}}
{{- if .Values.service.postgres.tls.certificate.name -}}
{{- printf .Values.service.postgres.tls.certificate.ca -}}
{{- else -}}
{{- printf "ca" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres hostname
*/}}
{{- define "postgres.postgres-hostname" -}}
{{- if .Values.config.postgres.hostname -}}
{{- printf .Values.config.postgres.hostname -}}
{{- else -}}
{{- printf "%s.%s.svc.cluster.local" (include "postgres.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "postgres.pgadmin-certificate" -}}
{{- if .Values.ingress.pgadmin.certificate -}}
{{- printf .Values.ingress.pgadmin.certificate -}}
{{- else -}}
{{- printf "pgadmin-letsencrypt" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pgadmin hostname
*/}}
{{- define "postgres.pgadmin-hostname" -}}
{{- if .Values.config.pgadmin.hostname -}}
{{- printf .Values.config.pgadmin.hostname -}}
{{- else -}}
{{- if .Values.ingress.pgadmin.enabled -}}
{{- printf .Values.ingress.pgadmin.hostname -}}
{{- else -}}
{{- printf "pgadmin.%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate pgadmin base url
*/}}
{{- define "postgres.pgadmin-base-url" -}}
{{- if .Values.config.pgadmin.baseUrl -}}
{{- printf .Values.config.pgadmin.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.pgadmin.enabled -}}
{{- $hostname := ((not (include "postgres.pgadmin-hostname" .)) | ternary .Values.ingress.pgadmin.hostname (include "postgres.pgadmin-hostname" .)) -}}
{{- $protocol := (.Values.ingress.pgadmin.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "postgres.pgadmin-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Grafana datasource name
*/}}
{{- define "postgres.grafana-datasource" -}}
{{- printf "%s-prometheus-%s" (include "postgres.name" .) .Release.Namespace -}}
{{- end -}}
