{{/*
Expand the name of the chart.
*/}}
{{- define "bonfire.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bonfire.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bonfire.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bonfire.labels" -}}
helm.sh/chart: {{ include "bonfire.chart" . }}
{{ include "bonfire.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bonfire.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bonfire.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bonfire.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bonfire.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
generate a tag from different parts of the values
*/}}
{{- define "bonfire.imagetag" -}}
{{- $version := .Values.image.version -}}
{{- if not $version -}}
{{- $version = .Chart.AppVersion -}}
{{- end -}}
{{- if not .Values.image.arch -}}
{{- printf "%s-%s" $version .Values.image.flavour }}
{{- else }}
{{- printf "%s-%s-%s" $version .Values.image.flavour .Values.image.arch }}
{{- end }}
{{- end }}
