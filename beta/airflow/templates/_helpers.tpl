{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "airflow.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate airflow certificate
*/}}
{{- define "airflow.airflow-certificate" -}}
{{- if .Values.ingress.airflow.certificate -}}
{{- printf .Values.ingress.airflow.certificate -}}
{{- else -}}
{{- printf "%s-gateway" (include "airflow.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate airflow hostname
*/}}
{{- define "airflow.airflow-hostname" -}}
{{- if .Values.config.airflow.hostname -}}
{{- printf .Values.config.airflow.hostname -}}
{{- else -}}
{{- if .Values.ingress.airflow.enabled -}}
{{- printf .Values.ingress.airflow.hostname -}}
{{- else -}}
{{- printf "%s-release-gateway.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate airflow base url
*/}}
{{- define "airflow.airflow-base-url" -}}
{{- if .Values.config.airflow.baseUrl -}}
{{- printf .Values.config.airflow.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.airflow.enabled -}}
{{- $hostname := ((not (include "airflow.airflow-hostname" .)) | ternary .Values.ingress.airflow.hostname (include "airflow.airflow-hostname" .)) -}}
{{- $protocol := (.Values.ingress.airflow.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "airflow.airflow-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate postgres url
*/}}
{{- define "airflow.postgres-url" -}}
{{- $postgres := .Values.config.postgres -}}
{{- if $postgres.url -}}
{{- printf $postgres.url -}}
{{- else -}}
{{- $credentials := ((or (not $postgres.username) (not $postgres.password)) | ternary "" (printf "%s:%s@" $postgres.username $postgres.password)) -}}
{{- printf "postgresql://%s%s:%s/%s" $credentials $postgres.host ($postgres.port | toString) $postgres.database -}}
{{- end -}}
{{- end -}}
