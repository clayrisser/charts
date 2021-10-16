{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "opensearch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "opensearch.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate opensearch certificate
*/}}
{{- define "opensearch.opensearch-certificate" -}}
{{- if (not .Values.service.opensearch.tls.certificate) -}}
{{- printf "%s-cert" (include "opensearch.name" .) -}}
{{- else -}}
{{- printf .Values.service.opensearch.tls.certificate -}}
{{- end -}}
{{- end -}}

{{/*
Calculate opensearch hostname
*/}}
{{- define "opensearch.opensearch-hostname" -}}
{{- if .Values.config.opensearch.hostname -}}
{{- printf .Values.config.opensearch.hostname -}}
{{- else -}}
{{- printf "%s-%s-opensearch-stack-ha.%s.svc.cluster.local" .Release.Name (include "opensearch.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Calculate opensearch base url
*/}}
{{- define "opensearch.opensearch-base-url" -}}
{{- if .Values.config.opensearchDashboards.baseUrl -}}
{{- printf .Values.config.opensearchDashboards.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.opensearchDashboards.enabled -}}
{{- $hostname := ((not (include "opensearch.opensearch-hostname" .)) | ternary .Values.ingress.opensearchDashboards.hostname (include "opensearch.opensearch-hostname" .)) -}}
{{- $protocol := (.Values.ingress.opensearchDashboards.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "opensearch.opensearch-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate opensearch-dashboards certificate
*/}}
{{- define "opensearch.opensearch-dashboards-certificate" -}}
{{- if .Values.ingress.opensearchDashboards.certificate -}}
{{- printf .Values.ingress.opensearchDashboards.certificate -}}
{{- else -}}
{{- printf "%s-opensearch-dashboards-letsencrypt" (include "opensearch.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate opensearch-dashboards hostname
*/}}
{{- define "opensearch.opensearch-dashboards-hostname" -}}
{{- if .Values.config.opensearchDashboards.hostname -}}
{{- printf .Values.config.opensearchDashboards.hostname -}}
{{- else -}}
{{- if .Values.ingress.opensearchDashboards.enabled -}}
{{- printf .Values.ingress.opensearchDashboards.hostname -}}
{{- else -}}
{{- printf "%s-opensearch.%s.svc.cluster.local" (include "opensearch.fullname" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate opensearch-dashboards base url
*/}}
{{- define "opensearch.opensearch-dashboards-base-url" -}}
{{- if .Values.config.opensearchDashboards.baseUrl -}}
{{- printf .Values.config.opensearchDashboards.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.opensearchDashboards.enabled -}}
{{- $hostname := ((not (include "opensearch.opensearch-dashboards-hostname" .)) | ternary .Values.ingress.opensearchDashboards.hostname (include "opensearch.opensearch-dashboards-hostname" .)) -}}
{{- $protocol := (.Values.ingress.opensearchDashboards.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "opensearch.opensearch-dashboards-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
