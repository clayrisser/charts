{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "teleport.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "teleport.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate certificate
*/}}
{{- define "teleport.certificate" }}
{{- if (not (empty .Values.ingress.certificate)) }}
{{- else }}
{{- printf "%s-letsencrypt" (include "teleport.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate hostname
*/}}
{{- define "teleport.hostname" }}
{{- if (not (empty .Values.config.hostname)) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.enabled }}
{{- printf (index .Values.ingress.hosts.teleport 0).name }}
{{- else }}
{{- printf "%s-teleport" (include "teleport.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate auth addr
*/}}
{{- define "teleport.auth_addr" }}
{{- printf "%s:%d" (include "teleport.hostname" .) (int .Values.service.nodePorts.teleport.auth) }}
{{- end }}

{{/*
Calculate proxy addr
*/}}
{{- define "teleport.proxy_addr" }}
{{- printf "%s:%d" (include "teleport.hostname" .) (int .Values.service.nodePorts.teleport.proxy) }}
{{- end }}

{{/*
Calculate web addr
*/}}
{{- define "teleport.web_addr" }}
{{- if (and (not .Values.ingress.enabled) (eq .Values.service.type "NodePort")) }}
{{- printf "%s:%d" (include "teleport.hostname" .) (int .Values.service.nodePorts.teleport.web) }}
{{- else }}
{{- printf "%s:%d" (include "teleport.hostname" .) 443 }}
{{- end }}
{{- end }}
