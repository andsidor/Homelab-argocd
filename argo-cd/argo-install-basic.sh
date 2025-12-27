#!/bin/bash

# ================================
# Argo CD Installer for Kubernetes
# ================================

# Set namespace
NAMESPACE="argocd"

echo "Step 1: Creating namespace '$NAMESPACE'..."
kubectl create namespace $NAMESPACE

echo "Step 2: Installing Argo CD..."
kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n $NAMESPACE --timeout=120s

echo "Step 3: Retrieving initial admin password..."
ADMIN_PASSWORD=$(kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Initial admin password: $ADMIN_PASSWORD"

# echo "Step 4: Port-forwarding Argo CD server to localhost:8080..."
# echo "Run the following command in a separate terminal to access the UI:"
# echo "kubectl port-forward svc/argocd-server -n $NAMESPACE 8080:443"
# echo "Then open https://localhost:8080 in your browser."

echo "Step 5: Install Argo CD CLI (optional if not installed)..."
if ! command -v argocd &> /dev/null
then
    echo "Downloading Argo CD CLI..."
    OS=$(uname | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-$OS-$ARCH
    chmod +x /usr/local/bin/argocd
    echo "Argo CD CLI installed!"
else
    echo "Argo CD CLI already installed."
fi

echo "✅ Argo CD installation complete!"
echo "Login with: argocd login localhost:8080 --username admin --password $ADMIN_PASSWORD"

