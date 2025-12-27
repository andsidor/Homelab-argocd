wq#!/bin/bash

# ================================
# Full Argo CD + GitOps Setup via Helm
# ================================

set -e

# -------------------------------
# Configuration
# -------------------------------
ARGOCD_NAMESPACE="argocd"
ARGOCD_SERVER="localhost:8080"
ARGOCD_ADMIN_USER="admin"

# Git repo and overlays
GIT_REPO="https://github.com/andsidor/Homelab-argocd"       # Replace with your GitOps repo
DEV_PATH="overlays/dev"
PROD_PATH="overlays/prod"
DEV_NS="dev"
PROD_NS="prod"

# -------------------------------
# Step 1: Install Argo CD via Helm (latest chart)
# -------------------------------
echo "Adding Helm repo..."
helm repo add argo https://argoproj.github.io/argo-helm || true
helm repo update

echo "Fetching latest Argo CD chart version..."
LATEST_VERSION=$(helm search repo argo/argo-cd --devel=false --output json | jq -r '.[0].version')
echo "Latest Argo CD chart version: $LATEST_VERSION"

echo "Installing Argo CD Helm chart..."
helm install argocd argo/argo-cd \
    --namespace $ARGOCD_NAMESPACE \
    --create-namespace \
    --version "$LATEST_VERSION"

# Save version to file
echo "$LATEST_VERSION" > argo-cd-chart-version.txt
echo "Helm chart version saved to argo-cd-chart-version.txt"

# Wait for server pod to be ready
echo "Waiting for Argo CD server pod to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $ARGOCD_NAMESPACE --timeout=180s || true

# -------------------------------
# Step 2: Install Argo CD CLI if missing
# -------------------------------
if ! command -v argocd &> /dev/null; then
    echo "Installing Argo CD CLI..."
    OS=$(uname | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-$OS-$ARCH
    chmod +x /usr/local/bin/argocd
    echo "Argo CD CLI installed."
fi

# -------------------------------
# Step 3: Login to Argo CD CLI
# -------------------------------
ADMIN_PASSWORD=$(kubectl -n $ARGOCD_NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Logging in to Argo CD CLI..."
argocd login $ARGOCD_SERVER --username $ARGOCD_ADMIN_USER --password "$ADMIN_PASSWORD" --insecure

# -------------------------------
# Step 4: Add Git repository
# -------------------------------
echo "Adding Git repository to Argo CD..."
argocd repo add "$GIT_REPO"

# -------------------------------
# Step 5: Create Dev Application
# -------------------------------
echo "Creating Dev application..."
argocd app create my-app-dev \
    --repo "$GIT_REPO" \
    --path "$DEV_PATH" \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace "$DEV_NS" || true

echo "Syncing Dev application..."
argocd app sync my-app-dev

# -------------------------------
# Step 6: Create Prod Application
# -------------------------------
# echo "Creating Prod application..."
# argocd app create my-app-prod \
#    --repo "$GIT_REPO" \
#    --path "$PROD_PATH" \
#    --dest-server https://kubernetes.default.svc \
#    --dest-namespace "$PROD_NS" || true
#
#echo "Syncing Prod application..."
#argocd app sync my-app-prod
#
# -------------------------------
# Done
# -------------------------------
echo "✅ GitOps setup complete via Helm!"
echo "Port-forward Argo CD server to access UI:"
echo "kubectl port-forward svc/argocd-server -n $ARGOCD_NAMESPACE 8080:443"
echo "Then open https://localhost:8080 in your browser."
