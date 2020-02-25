{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "elasticsearch.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate kibana certificate
*/}}
{{- define "elasticsearch.kibana-certificate" }}
{{- if (not (empty .Values.ingress.kibana.certificate)) }}
{{- printf .Values.ingress.kibana.certificate }}
{{- else }}
{{- printf "%s-kibana-letsencrypt" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate elasticsearch certificate
*/}}
{{- define "elasticsearch.elasticsearch-certificate" }}
{{- if (not (empty .Values.ingress.elasticsearch.certificate)) }}
{{- printf .Values.ingress.elasticsearch.certificate }}
{{- else }}
{{- printf "%s-elasticsearch-letsencrypt" (include "elasticsearch.fullname" .) }}
{{- end }}
{{- end }}
