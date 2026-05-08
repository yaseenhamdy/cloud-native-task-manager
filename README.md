
## Overview
This project is a small microservices-style application with:
- **Backend**: Python Flask API for task management, connected to PostgreSQL
- **Frontend**: React application for UI
- **Database**: PostgreSQL stateful service in Kubernetes
- **Kubernetes manifests**: `kustomize` base resources plus environment overlays for `dev`, `prod`, and `test`
- **Secrets**: Encrypted Postgres credentials using Bitnami Sealed Secrets (`kubeseal`)

## Project Structure

- `backend/`
  - `app.py` — Flask application with task CRUD, health checks, and Swagger UI
  - `requirements.txt` — Python dependencies
  - `dockerfile` — Docker image build for the backend
- `frontend/`
  - `package.json` — React application dependencies and scripts
  - `dockerfile` — Multistage Docker build for React into Nginx
- `k8s/`
  - `base/` — common Kustomize resources for backend, frontend, and database
  - `overlays/` — environment-specific patches for `dev`, `prod`, and `test`

## Backend API
The backend exposes these routes:
- `GET /api/tasks` — list tasks
- `POST /api/tasks` — create a task
- `PUT /api/tasks/<id>` — update a task
- `DELETE /api/tasks/<id>` — delete a task
- `GET /health` — health check with database status
- `GET /health/simple` — simple health status
- Swagger UI at `/api/docs`

## Prerequisites

- Docker
- Kubernetes cluster accessible via `kubectl` (e.g. Minikube, kind, k3d, or cloud cluster)
- `kubectl`
- `kustomize` (or `kubectl` with built-in kustomize support)
- `kubeseal` for Sealed Secrets management


## Install Important Tools

### kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

### kustomize
```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/
kustomize version
```

### kubeseal
```bash
sudo curl -L -o /usr/local/bin/kubeseal https://github.com/bitnami-labs/sealed-secrets/releases/latest/download/kubeseal-linux-amd64
sudo chmod +x /usr/local/bin/kubeseal
kubeseal --version
```



## Kubernetes Deployment

### Use Kustomize overlays
The repository includes base manifests plus overlays for environments.

Deploy the `dev` overlay:
```bash
kubectl apply -k k8s/overlays/dev
```

Deploy the `test` overlay:
```bash
kubectl apply -k k8s/overlays/test
```

Deploy the `prod` overlay:
```bash
kubectl apply -k k8s/overlays/prod
```

### Notes on the Kubernetes setup
- The backend deployment uses the `DATABASE_URL` secret from a sealed secret named `db-secrets`
- The database is a PostgreSQL stateful set

## Sealed Secrets (`kubeseal`)

This repository already stores a sealed secret manifest for database credentials at:
- `k8s/base/database/secrets.yaml`

If you need to update secrets locally, create an unsealed secret YAML first, then seal it with the cluster public key:

1. Create a plain secret file (`db-secret.yaml`):
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secrets
type: Opaque
stringData:
  DATABASE_URL: postgresql://postgres:postgres@postgres-service:5432/microservices_db
  POSTGRES_DB: microservices_db
  POSTGRES_USER: postgres
  POSTGRES_PASSWORD: postgres
```

2. Seal it using the cluster key:
```bash
kubeseal --format yaml < db-secret.yaml > k8s/base/database/secrets.yaml
```

3. Apply the sealed secret:
```bash
kubectl apply -f k8s/base/database/secrets.yaml
```

> Note: `kubeseal` requires access to the cluster public key. Use `--fetch-cert` if needed.

## Environment Variables
The backend reads `DATABASE_URL` from the Kubernetes secret.
If running locally without Kubernetes, set it in a `.env` file or export it directly.

Example `.env` file:
```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/microservices_db
```
