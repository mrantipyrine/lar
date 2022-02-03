{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "laravel.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "mysql.fullname" -}}
{{- printf "%s-%s" .Release.Name "mysql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "sqlproxy.fullname" -}}
{{- printf "%s-%s" .Release.Name "sqlproxy" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set environment
*/}}
{{- define "laravel.environment" -}}
{{- default "development" .Values.environment | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set mysql host
*/}}
{{- define "mysql.host" -}}
{{- if .Values.mysql.enabled -}}
{{- (include "mysql.fullname" . ) -}}.{{ .Release.Namespace }}.svc.cluster.local 
{{- else -}}
{{- .Values.mysql.mysqlHost | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set sqlproxy host
*/}}
{{- define "sqlproxy.host" -}}
{{- if .Values.sqlproxy.enabled -}}
{{- template "sqlproxy.fullname" . -}}
{{- else -}}
{{- .Values.sqlproxy.sqlproxyHost | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set redis host
*/}}
{{- define "redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- template "redis.fullname" . -}}
{{- else -}}
{{- .Values.redis.host | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set chart labels
*/}}
{{- define "laravel.labels" -}}
app: {{ default (include "laravel.fullname" . ) (include "laravel.environment" . )  }}
release: {{ .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}


{{/*
Set chart labels for cron
*/}}
{{- define "laravel.cronLabels" -}}
app: {{ printf "%s-%s" .Release.Name "cron" | trunc 63 | trimSuffix "-" }}
release: {{ .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Set chart labels for worker
*/}}
{{- define "laravel.workerLabels" -}}
app: {{ printf "%s-%s" .Release.Name "worker" | trunc 63 | trimSuffix "-" }}
release: {{ .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Set chart labels for extra worker
*/}}
{{- define "laravel.extra_workerLabels" -}}
app: {{ printf "%s-%s" .Release.Name "extra_worker" | trunc 63 | trimSuffix "-" }}
release: {{ .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Set secrets,configMap
*/}}
{{- define "laravel.envs" -}}
- secretRef:
    name: {{ template "laravel.fullname" . }}
- configMapRef:
    name: {{ template "laravel.fullname" . }}
{{- if .Values.customSecret }}
- secretRef:
    name: {{ .Values.customSecret }}
{{- end }}
{{- end }}