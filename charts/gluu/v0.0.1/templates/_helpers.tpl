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
{{- printf (index .Values.ingress.hosts.gluu 0).name }}
{{- else }}
{{- printf "%s-gluu" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate oxauth_url
*/}}
{{- define "gluu.oxauth_url" }}
{{- if (empty (include "gluu.hostname" . )) }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.gluu 0).name }}
{{- else }}
{{- printf "%s-oxauth:8080" (include "gluu.fullname" . ) }}
{{- end }}
{{- else }}
{{- printf (include "gluu.hostname" . ) }}
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
