{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "xtradb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "xtradb.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Calculate xtradb certificate
*/}}
{{- define "xtradb.xtradb-certificate" -}}
{{- if .Values.service.xtradb.tls.certificate.name -}}
{{- printf .Values.service.xtradb.tls.certificate.name -}}
{{- else -}}
{{- printf "%s-cert" (include "xtradb.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Calculate xtradb ca
*/}}
{{- define "xtradb.xtradb-ca" -}}
{{- if .Values.service.xtradb.tls.certificate.name -}}
{{- printf .Values.service.xtradb.tls.certificate.ca -}}
{{- else -}}
{{- printf "ca" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate xtradb hostname
*/}}
{{- define "xtradb.xtradb-hostname" -}}
{{- if .Values.config.xtradb.hostname -}}
{{- printf .Values.config.xtradb.hostname -}}
{{- else -}}
{{- printf "%s-pxc.%s.svc.cluster.local" (include "xtradb.name" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Calculate phpmyadmin certificate
*/}}
{{- define "xtradb.phpmyadmin-certificate" -}}
{{- if .Values.ingress.phpmyadmin.certificate -}}
{{- printf .Values.ingress.phpmyadmin.certificate -}}
{{- else -}}
{{- printf "phpmyadmin-letsencrypt" -}}
{{- end -}}
{{- end -}}

{{/*
Calculate phpmyadmin hostname
*/}}
{{- define "xtradb.phpmyadmin-hostname" -}}
{{- if .Values.config.phpmyadmin.hostname -}}
{{- printf .Values.config.phpmyadmin.hostname -}}
{{- else -}}
{{- if .Values.ingress.phpmyadmin.enabled -}}
{{- printf .Values.ingress.phpmyadmin.hostname -}}
{{- else -}}
{{- printf "phpmyadmin.%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Calculate phpmyadmin base url
*/}}
{{- define "xtradb.phpmyadmin-base-url" -}}
{{- if .Values.config.phpmyadmin.baseUrl -}}
{{- printf .Values.config.phpmyadmin.baseUrl -}}
{{- else -}}
{{- if .Values.ingress.phpmyadmin.enabled -}}
{{- $hostname := ((not (include "xtradb.phpmyadmin-hostname" .)) | ternary .Values.ingress.phpmyadmin.hostname (include "xtradb.phpmyadmin-hostname" .)) -}}
{{- $protocol := (.Values.ingress.phpmyadmin.tls | ternary "https" "http") -}}
{{- printf "%s://%s" $protocol $hostname -}}
{{- else -}}
{{- printf "http://%s" (include "xtradb.phpmyadmin-hostname" .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
