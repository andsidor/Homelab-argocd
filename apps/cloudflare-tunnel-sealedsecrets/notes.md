--


https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets



# Sealed Secrets
A Helm chart for Bitnami Sealed Secrets 

https://github.com/bitnami-labs/sealed-secrets/releases

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.32.2/controller.yaml


curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.32.2/kubeseal-0.32.2-linux-amd64.tar.gz"
tar -xvzf kubeseal-0.32.2-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

kubectl get secrets <service name> -n namespace

kubeseal --fetch-cert --controller-name sealed-secrets-controller --controller-namespace kube-system


openssl x509 -in cert.pem -text -noout


kubeseal < YAML to secure --scope (strict,namespace-wide,clusterwide-wide) cert.pem -o yaml > 



