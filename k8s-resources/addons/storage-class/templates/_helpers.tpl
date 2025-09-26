{{/*
Generate a default fully qualified app name.
*/}}
{{- define "storageclass-chart.fullname" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}