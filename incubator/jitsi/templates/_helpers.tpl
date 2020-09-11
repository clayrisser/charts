{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "jitsi.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "jitsi.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate web certificate
*/}}
{{- define "jitsi.web-certificate" }}
{{- if (not (empty .Values.ingress.web.certificate)) }}
{{- printf .Values.ingress.web.certificate }}
{{- else }}
{{- printf "%s-web-letsencrypt" (include "jitsi.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate jicofo hostname
*/}}
{{- define "jitsi.jicofo-hostname" }}
{{- if (and .Values.config.jicofo.hostname (not (empty .Values.config.jicofo.hostname))) }}
{{- printf .Values.config.jicofo.hostname }}
{{- else }}
{{- if .Values.ingress.jicofo.enabled }}
{{- printf .Values.ingress.jicofo.hostname }}
{{- else }}
{{- printf "%s-jitsi" (include "jitsi.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate xmpp hostname
*/}}
{{- define "jitsi.xmpp-hostname" }}
{{- if (and .Values.config.hostname (not (empty .Values.config.hostname))) }}
{{- printf .Values.config.hostname }}
{{- else }}
{{- if .Values.ingress.prosody.enabled }}
{{- printf .Values.ingress.prosody.hostname }}
{{- else }}
{{- printf "%s-prosody" (include "jitsi.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate web hostname
*/}}
{{- define "jitsi.web-hostname" }}
{{- if (and .Values.config.web.hostname (not (empty .Values.config.web.hostname))) }}
{{- printf .Values.config.web.hostname }}
{{- else }}
{{- if .Values.ingress.web.enabled }}
{{- printf .Values.ingress.web.hostname }}
{{- else }}
{{- printf "%s-web" (include "jitsi.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate web base url
*/}}
{{- define "jitsi.web-base-url" }}
{{- if (and .Values.config.web.baseUrl (not (empty .Values.config.web.baseUrl))) }}
{{- printf .Values.config.web.baseUrl }}
{{- else }}
{{- if .Values.ingress.web.enabled }}
{{- $hostname := ((empty (include "jitsi.web-hostname" .)) | ternary .Values.ingress.web.hostname (include "jitsi.web-hostname" .)) }}
{{- $path := (eq .Values.ingress.web.path "/" | ternary "" .Values.ingress.web.path) }}
{{- $protocol := (.Values.ingress.web.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "jitsi.web-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate jvb hostname
*/}}
{{- define "jitsi.jvb-hostname" }}
{{- if (and .Values.config.jvb.hostname (not (empty .Values.config.jvb.hostname))) }}
{{- printf .Values.config.jvb.hostname }}
{{- else }}
{{- if .Values.ingress.jvb.enabled }}
{{- printf .Values.ingress.jvb.hostname }}
{{- else }}
{{- printf "%s-jvb" (include "jitsi.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}
