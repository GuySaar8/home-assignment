# Helm Chart: Hello World Flask App

This README explains the custom Helm chart for deploying the Hello World Python Flask application to Kubernetes.

## What Has Been Done
- Created a custom Helm chart in `helm-hello-world/`.
- Chart includes templates for a Kubernetes Deployment and Service.
- Deployment uses the Docker image built in previous phases.
- Service exposes the application on port 80.

## How to Use

### Prerequisites
- Docker image for the app pushed to a container registry
- Helm installed ([Helm docs](https://helm.sh/docs/))
- Access to a Kubernetes cluster (e.g., EKS)

### Steps

1. **Update the Docker image repository in `values.yaml`**
   - Set `image.repository` to your Docker image location.

2. **Install the chart**
   ```bash
   helm install hello-world ./helm-hello-world
   ```

3. **Verify deployment**
   ```bash
   kubectl get pods
   kubectl get svc
   ```
   The service will expose the app on port 80 inside the cluster.

---
This README is specific to the Helm chart phase.
