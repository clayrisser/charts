{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "xbrowsersync.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "xbrowsersync.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "xbrowsersync.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.xbrowsersync 0).name }}
{{- else }}
{{- printf "%s-xbrowsersync" (include "xbrowsersync.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "xbrowsersync.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "xbrowsersync.hostname" . )) | (index .Values.ingress.hosts.xbrowsersync 0) (include "xbrowsersync.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "xbrowsersync.hostname" . )) }}
{{- printf "http://%s-xbrowsersync" (include "xbrowsersync.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "xbrowsersync.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongo_url
*/}}
{{- define "xbrowsersync.mongo_url" }}
{{- $mongo := .Values.config.mongo }}
{{- if $mongo.internal }}
{{- printf "mongodb://%s-mongo:27017/%s" (include "xbrowsersync.fullname" . ) $mongo.database }}
{{- else }}
{{- if $mongo.url }}
{{- printf $mongo.url }}
{{- else }}
{{- $credentials := (empty $mongo.username | ternary "" (printf "%s:%s" $mongo.username $mongo.password)) }}
{{- printf "mongodb://%s@%s:%s/%s" $credentials $mongo.host $mongo.port $mongo.database }}
{{- end }}
{{- end }}
{{- end }}
