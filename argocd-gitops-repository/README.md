# argocd-applications
- Contains Helm value file and Chart.yaml, these file are use for Helm template generation of the ArgoCD's Application CRD
- The application CRD contains Git repository and path to deployment manifest of services
- Helm generate template example:
```javascript
helm template . '--name-template=app-backend-service' '--values=./values/app-backend-service.yaml' > app-backend-service.yaml
```

# argocd-notification
- Contains manifest of secret and configMap of argoCD notification configuration
- a secret/argocd-notifications-secret contains Google Chat URL webhook
- ConfigMap/argocd-notifications-cm contains notification message and recipients/triggers

# Bootstrap instruction
- Deploy ArgoCD in namespace 'argocd' with terraform
- Configure ArgoCD GitHub webhook with terraform
- To configure Google Chat webhook alert and notification, create a secret object then apply ArgoCD notification ConfigMap
- Create ArgoCD application objecc in ArgoCD