{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rocketchat.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "rocketchat.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "rocketchat.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate rocketchat certificate
*/}}
{{- define "rocketchat.rocketchat-certificate" }}
{{- if (not (empty .Values.ingress.rocketchat.certificate)) }}
{{- printf .Values.ingress.rocketchat.certificate }}
{{- else }}
{{- printf "%s-rocketchat-letsencrypt" (include "rocketchat.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mongo express certificate
*/}}
{{- define "rocketchat.mongo-express-certificate" }}
{{- if (not (empty .Values.ingress.mongoExpress.certificate)) }}
{{- printf .Values.ingress.mongoExpress.certificate }}
{{- else }}
{{- printf "%s-mongo-express-letsencrypt" (include "rocketchat.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate rocketchat hostname
*/}}
{{- define "rocketchat.rocketchat-hostname" }}
{{- if (and .Values.config.rocketchat.hostname (not (empty .Values.config.rocketchat.hostname))) }}
{{- printf .Values.config.rocketchat.hostname }}
{{- else }}
{{- if .Values.ingress.rocketchat.enabled }}
{{- printf .Values.ingress.rocketchat.hostname }}
{{- else }}
{{- printf "%s-rocketchat" (include "rocketchat.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate rocketchat base url
*/}}
{{- define "rocketchat.rocketchat-base-url" }}
{{- if (and .Values.config.rocketchat.baseUrl (not (empty .Values.config.rocketchat.baseUrl))) }}
{{- printf .Values.config.rocketchat.baseUrl }}
{{- else }}
{{- if .Values.ingress.rocketchat.enabled }}
{{- $hostname := ((empty (include "rocketchat.rocketchat-hostname" .)) | ternary .Values.ingress.rocketchat.hostname (include "rocketchat.rocketchat-hostname" .)) }}
{{- $path := (eq .Values.ingress.rocketchat.path "/" | ternary "" .Values.ingress.rocketchat.path) }}
{{- $protocol := (.Values.ingress.rocketchat.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "rocketchat.rocketchat-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongodb url
*/}}
{{- define "rocketchat.mongodb-url" }}
{{- $mongodb := .Values.config.mongodb }}
{{- if $mongodb.internal }}
{{- $credentials := (empty $mongodb.password | ternary "" (printf "root:%s@" $mongodb.password)) }}
{{- printf "mongodb://%s%s-mongodb:27017/%s?authSource=admin&replSet=rs0" $credentials (include "rocketchat.fullname" .) $mongodb.database }}
{{- else }}
{{- $credentials := (empty $mongodb.username | ternary "" (printf "%s:%s@" $mongodb.username $mongodb.password)) }}
{{- if $mongodb.url }}
{{- printf $mongodb.url }}
{{- else }}
{{- printf "mongodb://%s%s:%s/%s?authSource=admin" $credentials $mongodb.host $mongodb.port $mongodb.database }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongodb oplog url
*/}}
{{- define "rocketchat.mongodb-oplog-url" }}
{{- $mongodb := .Values.config.mongodb }}
{{- if $mongodb.internal }}
{{- $credentials := (empty $mongodb.password | ternary "" (printf "root:%s@" $mongodb.password)) }}
{{- printf "mongodb://%s%s-mongodb:27017/local?authSource=admin&replSet=rs0" $credentials (include "rocketchat.fullname" .) }}
{{- else }}
{{- $credentials := (empty $mongodb.username | ternary "" (printf "%s:%s@" $mongodb.username $mongodb.password)) }}
{{- if $mongodb.url }}
{{- printf $mongodb.url }}
{{- else }}
{{- printf "mongodb://%s%s:%s/local?authSource=admin&replSet=rs0" $credentials $mongodb.host $mongodb.port }}
{{- end }}
{{- end }}
{{- end }}
