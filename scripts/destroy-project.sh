#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl"
  curl -LO "https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi

echo "=== Connecting to tools cluster ==="
aws eks update-kubeconfig --name tools-cluster --region "$REGION"

echo "=== Deleting ArgoCD applications (root-app + app-of-apps) ==="
kubectl delete -f "$REPO_ROOT/k8s/root-app.yaml" --ignore-not-found || true
kubectl delete -f "$REPO_ROOT/k8s/app-of-apps/" --ignore-not-found || true

echo "=== Waiting for ArgoCD applications to be removed ==="
for i in $(seq 1 60); do
  COUNT=$(kubectl get applications -n argo-cd -o name 2>/dev/null | wc -l)
  if [ "$COUNT" -eq 0 ]; then
    echo "All ArgoCD applications deleted"
    break
  fi
  if [ "$i" -eq 60 ]; then
    echo "WARNING: ArgoCD applications still present after timeout; continuing anyway"
  fi
  sleep 5
done

echo "=== Removing leftover load balancers (safety net) ==="
LB_ARNS=$(aws elbv2 describe-load-balancers --region "$REGION" \
  --query "LoadBalancers[?starts_with(LoadBalancerName,'k8s-')].LoadBalancerArn" \
  --output text 2>/dev/null || true)
if [ -n "$LB_ARNS" ]; then
  for arn in $LB_ARNS; do
    echo "Deleting load balancer: $arn"
    aws elbv2 delete-load-balancer --load-balancer-arn "$arn" --region "$REGION" || true
  done
else
  echo "No leftover load balancers found"
fi

echo "=== ArgoCD cleanup complete ==="