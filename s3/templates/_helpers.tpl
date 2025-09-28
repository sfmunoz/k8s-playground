{{- define "pvName" -}}
{{- printf "s3-pv-%s" .Release.Namespace }}
{{- end }}
