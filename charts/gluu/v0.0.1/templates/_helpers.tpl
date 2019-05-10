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
Calculate oxauth_hostname
*/}}
{{- define "gluu.oxauth_hostname" }}
{{- if (not (empty .Values.config.oxauthHostname)) }}
{{- printf .Values.config.oxauthHostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.oxauth 0).name }}
{{- else }}
{{- printf "%s-oxauth" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate oxtrust_hostname
*/}}
{{- define "gluu.oxtrust_hostname" }}
{{- if (not (empty .Values.config.oxtrustHostname)) }}
{{- printf .Values.config.oxtrustHostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.oxtrust 0).name }}
{{- else }}
{{- printf "%s-oxtrust" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate oxpassport_hostname
*/}}
{{- define "gluu.oxpassport_hostname" }}
{{- if (not (empty .Values.config.oxpassportHostname)) }}
{{- printf .Values.config.oxpassportHostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.oxpassport 0).name }}
{{- else }}
{{- printf "%s-oxpassport" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate oxshibboleth_hostname
*/}}
{{- define "gluu.oxshibboleth_hostname" }}
{{- if (not (empty .Values.config.oxshibbolethHostname)) }}
{{- printf .Values.config.oxshibbolethHostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.oxshibboleth 0).name }}
{{- else }}
{{- printf "%s-oxshibboleth" (include "gluu.fullname" . ) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate oxauth_url
*/}}
{{- define "gluu.oxauth_url" }}
{{- if (empty (include "gluu.oxauth_hostname" . )) }}
{{- if .Values.ingress.enabled }}
{{- printf ((empty (include "gluu.oxauth_hostname" . )) | (index .Values.ingress.hosts.gluu 0).name (include "gluu.oxauth_hostname" . )) }}
{{- else }}
{{- printf "%s-gluu:8080" (include "gluu.oxauth_hostname" . ) }}
{{- end }}
{{- else }}
{{- printf (include "gluu.oxauth_hostname" . ) }}
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
