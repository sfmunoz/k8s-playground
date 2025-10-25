{{- define "postgres.rclone.conf" -}}
[s3]
type = s3
provider = AWS
access_key_id = {{ required "S3_ACCESS_KEY_ID missing" .S3_ACCESS_KEY_ID }}
secret_access_key = {{ required "S3_SECRET_ACCESS_KEY missing" .S3_SECRET_ACCESS_KEY }}
region = {{ required "S3_REGION missing" .S3_REGION }}
location_constraint = {{ required "S3_REGION missing" .S3_REGION }}

[{{ required "ALIAS_NAME missing" .ALIAS_NAME }}]
type = crypt
remote = s3:{{ required "S3_BUCKET missing" .S3_BUCKET }}/{{ required "S3_FOLDER missing" .S3_FOLDER }}
password = {{ required "CRYPT_PASSWORD missing" .CRYPT_PASSWORD }}
password2 = {{ required "CRYPT_PASSWORD2 missing" .CRYPT_PASSWORD2 }}

[{{ required "ALIAS_NAME missing" .ALIAS_NAME }}raw]
type = alias
remote = s3:{{ required "S3_BUCKET missing" .S3_BUCKET }}/{{ required "S3_FOLDER missing" .S3_FOLDER }}
{{ end }}
