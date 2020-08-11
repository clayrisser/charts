{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kube-api-proxy.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "kube-api-proxy.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "kube-api-proxy.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate kube api proxy certificate
*/}}
{{- define "kube-api-proxy.kube-api-proxy-certificate" }}
{{- if (not (empty .Values.ingress.kubeApiProxy.certificate)) }}
{{- printf .Values.ingress.kubeApiProxy.certificate }}
{{- else }}
{{- printf "%s-kube-api-proxy-letsencrypt" (include "kube-api-proxy.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate kube api proxy hostname
*/}}
{{- define "kube-api-proxy.kube-api-proxy-hostname" }}
{{- if (and .Values.config.kubeApiProxy.hostname (not (empty .Values.config.kubeApiProxy.hostname))) }}
{{- printf .Values.config.kubeApiProxy.hostname }}
{{- else }}
{{- if .Values.ingress.kubeApiProxy.enabled }}
{{- printf .Values.ingress.kubeApiProxy.hostname }}
{{- else }}
{{- printf "%s-kube-api-proxy" (include "kube-api-proxy.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate kube api proxy base url
*/}}
{{- define "kube-api-proxy.kube-api-proxy-base-url" }}
{{- if (and .Values.config.kubeApiProxy.baseUrl (not (empty .Values.config.kubeApiProxy.baseUrl))) }}
{{- printf .Values.config.kubeApiProxy.baseUrl }}
{{- else }}
{{- if .Values.ingress.kubeApiProxy.enabled }}
{{- $hostname := ((empty (include "kube-api-proxy.kube-api-proxy-hostname" .)) | ternary .Values.ingress.kubeApiProxy.hostname (include "kube-api-proxy.kube-api-proxy-hostname" .)) }}
{{- $path := (eq .Values.ingress.kubeApiProxy.path "/" | ternary "" .Values.ingress.kubeApiProxy.path) }}
{{- $protocol := (.Values.ingress.kubeApiProxy.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "kube-api-proxy.kube-api-proxy-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
