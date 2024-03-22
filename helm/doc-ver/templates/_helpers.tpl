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
