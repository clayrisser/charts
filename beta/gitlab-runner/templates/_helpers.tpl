{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitlab-runner.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "gitlab-runner.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate gitlab-runner certificate
*/}}
{{- define "gitlab-runner.gitlab-runner-certificate" }}
{{- if (not (empty .Values.ingress.gitlab-runner.certificate)) }}
{{- printf .Values.ingress.gitlab-runner.certificate }}
{{- else }}
{{- printf "%s-gitlab-runner-letsencrypt" (include "gitlab-runner.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate gitlab-runner hostname
*/}}
{{- define "gitlab-runner.gitlab-runner-hostname" }}
{{- if (and .Values.config.gitlab-runner.hostname (not (empty .Values.config.gitlab-runner.hostname))) }}
{{- printf .Values.config.gitlab-runner.hostname }}
{{- else }}
{{- if .Values.ingress.gitlab-runner.enabled }}
{{- printf .Values.ingress.gitlab-runner.hostname }}
{{- else }}
{{- printf "%s-gitlab-runner" (include "gitlab-runner.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate gitlab-runner base url
*/}}
{{- define "gitlab-runner.gitlab-runner-base-url" }}
{{- if (and .Values.config.gitlab-runner.baseUrl (not (empty .Values.config.gitlab-runner.baseUrl))) }}
{{- printf .Values.config.gitlab-runner.baseUrl }}
{{- else }}
{{- if .Values.ingress.gitlab-runner.enabled }}
{{- $hostname := ((empty (include "gitlab-runner.gitlab-runner-hostname" .)) | ternary .Values.ingress.gitlab-runner.hostname (include "gitlab-runner.gitlab-runner-hostname" .)) }}
{{- $protocol := (.Values.ingress.gitlab-runner.tls | ternary "https" "http") }}
{{- printf "%s://%s" $protocol $hostname }}
{{- else }}
{{- printf "http://%s" (include "gitlab-runner.gitlab-runner-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
