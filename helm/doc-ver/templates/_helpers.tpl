{{ define "docver.dockerconfig_hlp" -}}
_json_key:{{ . | b64dec }}
{{- end }}

{{ define "docver.dockerconfig" }}
{
	"auths": {
		"eu.gcr.io": {
      "auth": "{{ (include "docver.dockerconfig_hlp" .) | b64enc }}"
    }
  }
}
{{ end }}

{{- define "docver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" -}}
{{- end -}}

{{- define "docver.name" -}}
{{- default .Chart.Name .Values.singleImage.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "docver.fullname" -}}
{{- if .Values.singleImage.fullnameOverride -}}
{{- .Values.singleImage.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "docver.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "docver.labels" -}}
app.kubernetes.io/name: {{ include "docver.name" . }}
helm.sh/chart: {{ include "docver.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "docver.serviceAccountName" -}}
{{- if .Values.singleImage.serviceAccount.create -}}
{{- default (include "docver.fullname" .) .Values.singleImage.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.singleImage.serviceAccount.name -}}
{{- end -}}
{{- end -}}