# Hello World Flask App - Helm Chart

Helm chart for deploying the Hello World Python Flask application with PostgreSQL database integration to Kubernetes.

## Overview

This Helm chart provides:
- **Flask Application Deployment**: Scalable containerized Flask app
- **Load Balancing**: Service configuration with LoadBalancer support
- **Ingress Support**: Optional ingress for external traffic

## Chart Components

### Templates
```
templates/
├── deployment.yaml      # Main application deployment
├── service.yaml        # LoadBalancer service (port 80)
├── ingress.yaml        # Optional ingress configuration
└── _helpers.tpl       # Template helpers and labels
```

## Installation

### Prerequisites
- Kubernetes cluster (EKS, GKE, Minikube, etc.)
- Helm 3.x installed
- `kubectl` configured for your cluster
- Docker image available in registry
- Database credentials stored in Kubernetes secret

### Quick Start

1. **Install the chart**:
   ```bash
   helm install hello-world ./helm-hello-world
   ```

2. **Verify deployment**:
   ```bash
   kubectl get pods -l app.kubernetes.io/name=hello-world
   kubectl get svc hello-world
   ```

3. **Check application health**:
   ```bash
   kubectl port-forward svc/hello-world 8080:80
   curl http://localhost:8080/health
   ```

## Development

### Testing Chart Templates
```bash
# Dry run to validate templates
helm install hello-world ./helm-hello-world --dry-run --debug

# Lint chart
helm lint ./helm-hello-world

# Template rendering
helm template hello-world ./helm-hello-world
```
