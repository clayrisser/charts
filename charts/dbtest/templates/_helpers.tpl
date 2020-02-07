{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dbtest.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "dbtest.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate nginx certificate
*/}}
{{- define "dbtest.nginx-certificate" }}
{{- if (not (empty .Values.ingress.nginx.certificate)) }}
{{- printf .Values.ingress.nginx.certificate }}
{{- else }}
{{- printf "%s-nginx-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate kibana certificate
*/}}
{{- define "dbtest.kibana-certificate" }}
{{- if (not (empty .Values.ingress.kibana.certificate)) }}
{{- printf .Values.ingress.kibana.certificate }}
{{- else }}
{{- printf "%s-kibana-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mongo express certificate
*/}}
{{- define "dbtest.mongo-express-certificate" }}
{{- if (not (empty .Values.ingress.mongoExpress.certificate)) }}
{{- printf .Values.ingress.mongoExpress.certificate }}
{{- else }}
{{- printf "%s-mongo-express-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpmyadmin certificate
*/}}
{{- define "dbtest.phpmyadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpmyadmin.certificate)) }}
{{- printf .Values.ingress.phpmyadmin.certificate }}
{{- else }}
{{- printf "%s-phpmyadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "dbtest.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate phpredisadmin certificate
*/}}
{{- define "dbtest.phpredisadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpredisadmin.certificate)) }}
{{- printf .Values.ingress.phpredisadmin.certificate }}
{{- else }}
{{- printf "%s-phpredisadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate nginx hostname
*/}}
{{- define "dbtest.nginx-hostname" }}
{{- if (and .Values.config.nginx.hostname (not (empty .Values.config.nginx.hostname))) }}
{{- printf .Values.config.nginx.hostname }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- printf .Values.ingress.nginx.hostname }}
{{- else }}
{{- printf "%s-nginx" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate nginx base url
*/}}
{{- define "dbtest.nginx-base-url" }}
{{- if (and .Values.config.nginx.baseUrl (not (empty .Values.config.nginx.baseUrl))) }}
{{- printf .Values.config.nginx.baseUrl }}
{{- else }}
{{- if .Values.ingress.nginx.enabled }}
{{- $hostname := ((empty (include "dbtest.nginx-hostname" .)) | ternary .Values.ingress.nginx.hostname (include "dbtest.nginx-hostname" .)) }}
{{- $path := (eq .Values.ingress.nginx.path "/" | ternary "" .Values.ingress.nginx.path) }}
{{- $protocol := (.Values.ingress.nginx.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "dbtest.nginx-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate kibana certificate
*/}}
{{- define "dbtest.kibana-certificate" }}
{{- if (not (empty .Values.ingress.kibana.certificate)) }}
{{- printf .Values.ingress.kibana.certificate }}
{{- else }}
{{- printf "%s-kibana-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mongodb server
*/}}
{{- define dbtest.mongodb-server" }}
{{- if .Values.config.replicaSet.enabled }}
{{- printf "%s-mongodb-0.%s-mongodb-gvr.%s.svc,%s-mongodb-1.%s-mongodb-gvr.%s.svc,%s-mongodb-2.%s-mongodb-gvr.%s.svc" (include dbtest.fullname" .) (include dbtest.fullname" .) .Release.Namespace (include dbtest.fullname" .) (include dbtest.fullname" .) .Release.Namespace (include dbtest.fullname" .) (include dbtest.fullname" .) .Release.Namespace }}
{{- else }}
{{- printf "%s-mongodb" (include dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mongodb url
*/}}
{{- define "dbtest.mongodb-url" }}
{{- $mongodb := .Values.config.mongodb }}
{{- if $mongodb.internal }}
{{- printf dbtest://%s-mongodb:27017/%s" (include "dbtest.fullname" .) $mongodb.database }}
{{- else }}
{{- if $mongodb.url }}
{{- printf $mongodb.url }}
{{- else }}
{{- $credentials := (empty $mongodb.username | ternary "" (printf "%s:%s" $mongodb.username $mongodb.password)) }}
{{- printf dbtest://%s@%s:%s/%s" $credentials $mongodb.host $mongodb.port $mongodb.database }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate mongo express certificate
*/}}
{{- define "dbtest.mongo-express-certificate" }}
{{- if (not (empty .Values.ingress.mongoExpress.certificate)) }}
{{- printf .Values.ingress.mongoExpress.certificate }}
{{- else }}
{{- printf "%s-mongo-express-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate mysql url
*/}}
{{- define "dbtest.mysql-url" }}
{{- $mysql := .Values.config.mysql }}
{{- if $mysql.internal }}
{{- $credentials := (printf "%s:%s" $mysql.username $mysql.password) }}
{{- printf "jdbc:mysql://%s@%s-mysql:3306/%s" $credentials (include "dbtest.fullname" .) $mysql.database }}
{{- else }}
{{- if $mysql.url }}
{{- printf $mysql.url }}
{{- else }}
{{- printf "jdbc:mysql://%s@%s:%s/%s" $credentials $mysql.host $mysql.port $mysql.database }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate phpmyadmin certificate
*/}}
{{- define "dbtest.phpmyadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpmyadmin.certificate)) }}
{{- printf .Values.ingress.phpmyadmin.certificate }}
{{- else }}
{{- printf "%s-phpmyadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate postgres url
*/}}
{{- define "dbtest.postgres-url" }}
{{- $postgres := .Values.config.postgres }}
{{- if $postgres.internal }}
{{- $credentials := (printf "%s:%s" $postgres.username $postgres.password) }}
{{- printf "postgresql://%s@%s-postgres:5432/%s" $credentials (include "dbtest.fullname" .) $postgres.database }}
{{- else }}
{{- if $postgres.url }}
{{- printf $postgres.url }}
{{- else }}
{{- printf "postgresql://%s@%s:%s/%s" $credentials $postgres.host $postgres.port $postgres.database }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate pgadmin certificate
*/}}
{{- define "dbtest.pgadmin-certificate" }}
{{- if (not (empty .Values.ingress.pgadmin.certificate)) }}
{{- printf .Values.ingress.pgadmin.certificate }}
{{- else }}
{{- printf "%s-pgadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate redis url
*/}}
{{- define "dbtest.redis-url" }}
{{- $redis := .Values.config.redis }}
{{- if $redis.internal }}
{{- $credentials := (printf "%s:%s" $redis.username $redis.password) }}
{{- printf "redis://%s-redis:6379" (include "dbtest.fullname" .) }}
{{- else }}
{{- if $redis.url }}
{{- printf $redis.url }}
{{- else }}
{{- $credentials := (empty $redis.username | ternary "" (printf "%s:%s" $redis.username $redis.password)) }}
{{- printf "redis://%s@%s:%s" $credentials $redis.host $redis.port }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate phpredisadmin certificate
*/}}
{{- define "dbtest.phpredisadmin-certificate" }}
{{- if (not (empty .Values.ingress.phpredisadmin.certificate)) }}
{{- printf .Values.ingress.phpredisadmin.certificate }}
{{- else }}
{{- printf "%s-phpredisadmin-letsencrypt" (include "dbtest.fullname" .) }}
{{- end }}
{{- end }}
