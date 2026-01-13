{{/*
Render a container template used by different kubernetes manifests in this chart
*/}}
{{- define "<CHARTNAME>.containerManifest" -}}
name: {{ .containerName }}
securityContext:
{{- toYaml ( default dict .container.securityContext ) | nindent 2 }}
image: "{{ (.container.image | default dict).repository | default (.root.Values.image.repository) }}:{{ (.container.image| default dict).tag | default (.root.Values.image.tag | default .root.Chart.AppVersion) }}"
imagePullPolicy: {{ (.container.image | default dict).pullPolicy | default (.root.Values.image.pullPolicy)  }}
{{- if .container.env }}
env:
{{- range $key, $val := .container.env }}
  - name: {{ $key }}
    value: {{ tpl $val $.root | quote }}
{{- end }}
{{- end }}
{{- if or (and .container.config (or .container.config.env .container.config.secretEnv)) .container.extraEnvFrom }}
envFrom:
{{- if and .container.config .container.config.env }}
- configMapRef:
    name: {{ include "<CHARTNAME>.containerObjectName" (dict "root" .root "container" .containerName) }}
{{- end }}
{{- if and .container.config .container.config.secretEnv }}
- secretRef:
    name: {{ include "<CHARTNAME>.containerObjectName" (dict "root" .root "container" .containerName) }}
{{- end }}
{{- if .container.extraEnvFrom }}
{{- tpl (toYaml .container.extraEnvFrom) .root | nindent 0 }}
{{- end }}
{{- end }}
{{- with .container.ports }}
ports:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .container.command }}
command:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .container.args }}
args:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .container.livenessProbe }}
livenessProbe:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .container.readinessProbe }}
readinessProbe:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .container.startupProbe }}
startupProbe:
{{- toYaml . | nindent 2 }}
{{- end }}
resources:
{{- toYaml ( default dict .container.resources ) | nindent 2 }}
{{- if .container.persistence }}
{{- $_ := set .volumesHolder .containerName .container.persistence -}}
{{- end }}
{{- if or .container.persistence .container.extraVolumeMounts }}
volumeMounts:
{{- range $volName, $volSpec := .container.persistence }}
  - name: {{ $volName }}
    mountPath: {{ required (printf "%s containers[%d].persistence.%s.mountPath must be set" .objectDescription .containerName $volName) $volSpec.mountPath }}
{{- end }}
{{- range $extraMount := .container.extraVolumeMounts }}
  - {{- toYaml $extraMount | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
