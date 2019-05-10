{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gluu.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "gluu.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate hostname
*/}}
{{- define "gluu.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.opendj 0).name }}
{{- else }}
{{- printf "%s-gluu" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate base_url
*/}}
{{- define "gluu.base_url" }}
{{- if (not (empty .Values.config.base_url)) }}
{{- printf .Values.config.base_url }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- $host := ((empty (include "gluu.hostname" . )) | (index .Values.ingress.hosts.gluu 0) (include "gluu.hostname" . )) }}
{{- $protocol := (.Values.ingress.tls | ternary "https" "http") }}
{{- $path := (eq $host.path "/" | ternary "" $host.path) }}
{{- printf "%s://%s%s" $protocol $host.name $path }}
{{- else }}
{{- if (empty (include "gluu.hostname" . )) }}
{{- printf "http://%s-gluu" (include "gluu.hostname" . ) }}
{{- else }}
{{- printf "http://%s" (include "gluu.hostname" . ) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate redis_url
*/}}
{{- define "gluu.redis_url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "gluu.fullname" . ) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}
