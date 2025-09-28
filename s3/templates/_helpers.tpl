{{- define "pvName" -}}
{{- printf "s3-pv-%s" .Release.Namespace }}
{{- end }}

{{- define "volumeHandle" -}}
{{- printf "s3-vol-%s" .Release.Namespace }}
{{- end }}
