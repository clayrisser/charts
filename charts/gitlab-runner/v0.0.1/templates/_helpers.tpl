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
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "gitlab-runner.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate gitlab runner hostname
*/}}
{{- define "gitlab-runner.gitlab-runner-hostname" }}
{{- if (and .Values.config.gitlabRunner.hostname (not (empty .Values.config.gitlabRunner.hostname))) }}
{{- printf .Values.config.gitlabRunner.hostname }}
{{- else }}
{{- printf "%s-gitlab-runner" (include "gitlab-runner.fullname" .) }}
{{- end }}
{{- end }}
