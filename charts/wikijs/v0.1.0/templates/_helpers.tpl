{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wikijs.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "wikijs.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "wikijs.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := (index .Values.ingress.hosts.wikijs 0) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- printf "http://%s-wikijs" (include "wikijs.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongo_url
*/}}
{{- define "wikijs.mongo_url" }}
{{- $mongo := .Values.config.mongo }}
{{- if $mongo.internal }}
{{- printf "mongodb://%s-mongo:27017/%s" (include "wikijs.fullname" . ) $mongo.database }}
{{- else }}
{{- if $mongo.url }}
{{- printf $mongo.url }}
{{- else }}
{{- $credentials := (empty $mongo.username | ternary "" (printf "%s:%s" $mongo.username $mongo.password)) }}
{{- printf "mongodb://%s@%s:%s/%s" $credentials $mongo.host $mongo.port $mongo.database }}
{{- end }}
{{- end }}
{{- end }}
