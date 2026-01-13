{{/*
Expand the name of the chart.
*/}}
{{- define "<CHARTNAME>.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "<CHARTNAME>.fullname" -}}
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
{{- define "<CHARTNAME>.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "<CHARTNAME>.labels" -}}
helm.sh/chart: {{ include "<CHARTNAME>.chart" . }}
{{ include "<CHARTNAME>.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "<CHARTNAME>.selectorLabels" -}}
app.kubernetes.io/name: {{ include "<CHARTNAME>.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: {{ include "<CHARTNAME>.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "<CHARTNAME>.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "<CHARTNAME>.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the persistent volume claim
*/}}
{{- define "<CHARTNAME>.pvcName" -}}
  {{- if .volumeSpec.existingClaim -}}
    {{- printf "%s" (tpl .volumeSpec.existingClaim .root) -}}
  {{- else -}}
      {{- printf "%s-%s" .volumeName  (include "<CHARTNAME>.fullname" .root) -}}
  {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified object name based on container name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "<CHARTNAME>.containerObjectName" -}}
{{- printf "%s-%s" .container (include "<CHARTNAME>.fullname" .root ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified job name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "<CHARTNAME>.jobName" -}}
{{- printf "%s-%s" .job (include "<CHARTNAME>.fullname" .root ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified cronjob name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "<CHARTNAME>.cronjobName" -}}
{{- printf "%s-%s" .cronjob (include "<CHARTNAME>.fullname" .root ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified extra Deployment name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "<CHARTNAME>.deploymentName" -}}
{{- printf "%s-%s" .deployment (include "<CHARTNAME>.fullname" .root ) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels for extra Deployment
*/}}
{{- define "<CHARTNAME>.extraDeploymentSelectorLabels" -}}
app.kubernetes.io/name: {{ include "<CHARTNAME>.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ include "<CHARTNAME>.deploymentName" . }}
{{- end }}