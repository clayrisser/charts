{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mongodb.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "mongodb.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate mongodb server
*/}}
{{- define "mongodb.mongodb-server" }}
{{- if .Values.config.replicaSet.enabled }}
{{- printf "%s-mongodb-0.%s-gvr.%s.svc,%s-mongodb-1.%s-gvr.%s.svc,%s-mongodb-2.%s-gvr.%s.svc" (include "mongodb.fullname" .) (include "mongodb.fullname" .) .Release.Namespace (include "mongodb.fullname" .) (include "mongodb.fullname" .) .Release.Namespace (include "mongodb.fullname" .) (include "mongodb.fullname" .) .Release.Namespace }}
{{- else }}
{{- printf (include "mongodb.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mongo express certificate
*/}}
{{- define "mongodb.mongo-express-certificate" }}
{{- if (not (empty .Values.ingress.mongoExpress.certificate)) }}
{{- printf .Values.ingress.mongoExpress.certificate }}
{{- else }}
{{- printf "%s-mongo-express-letsencrypt" (include "mongodb.fullname" .) }}
{{- end }}
{{- end }}
