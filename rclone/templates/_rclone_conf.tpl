{{- define "rclone.conf" -}}
[s3]
type = s3
provider = AWS
access_key_id = {{ required "S3_ACCESS_KEY_ID missing" .S3_ACCESS_KEY_ID }}
secret_access_key = {{ required "S3_SECRET_ACCESS_KEY missing" .S3_SECRET_ACCESS_KEY }}
region = {{ required "S3_REGION missing" .S3_REGION }}
location_constraint = {{ required "S3_REGION missing" .S3_REGION }}

[{{ required "ALIAS_NAME missing" .ALIAS_NAME }}]
type = alias
remote = s3:{{ required "S3_BUCKET missing" .S3_BUCKET }}/{{ .S3_FOLDER }}
{{ end }}
