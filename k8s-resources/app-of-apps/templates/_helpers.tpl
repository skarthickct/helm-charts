{{- define "addon-apps.application" -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ .name }}
  namespace: argocd
spec:
  project: addon-project
  source:
    repoURL: {{ .repoURL }}
    targetRevision: HEAD
    path: {{ .chartPath }}
    helm:
      valueFiles:
        - {{ .valuesFile }}
  destination:
    server: https://kubernetes.default.svc
    namespace: {{ .namespace }}
  syncPolicy:
    automated: 
        prune: {{.prune}}
        selfHeal: {{.selfHeal}}
        allowEmpty: {{.allowEmpty}}
    syncOptions: 
    {{- range .syncOptions }}
      - {{ . }}
    {{- end }}
    retry:
      limit: 5 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 5s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
        factor: 2 # a factor to multiply the base duration after each failed retry
        maxDuration: 3m # the maximum amount of time allowed for the backoff strategy
  ignoreDifferences:
    - group: apps
      kind: Deployment
      jsonPointers:
        - /spec/replicas
        - /metadata/annotations
    - group: argoproj.io
      kind: Rollout
      jsonPointers:
        - /spec/replicas
        - /metadata/annotations
    - group: "*"
      kind: "*"
      managedFieldsManagers:
      - kube-controller-manager
{{- end -}}


