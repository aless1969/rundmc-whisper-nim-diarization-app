{{/*
Expand the name of the chart.
*/}}
{{- define "rundmc-whisper-nim-diarization-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rundmc-whisper-nim-diarization-app.fullname" -}}
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
{{- define "rundmc-whisper-nim-diarization-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rundmc-whisper-nim-diarization-app.labels" -}}
helm.sh/chart: {{ include "rundmc-whisper-nim-diarization-app.chart" . }}
{{ include "rundmc-whisper-nim-diarization-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rundmc-whisper-nim-diarization-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rundmc-whisper-nim-diarization-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "rundmc-whisper-nim-diarization-app.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rundmc-whisper-nim-diarization-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rundmc-whisper-nim-diarization-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
