TO do list:


<!-- Update comments  -->
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm search repo ingress-nginx -- versions


<!-- Template to export from Helmchat to YAML CRD-->
<!-- and save in selected directory -->
helm template ingress-nginx  ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--version 4.13.2 \
--namespace ingress-nginx \
> ./infrastructure/ingress-nginx/ingress-ngnix-1.13.2.yaml

<!--____________________________________________________ -->

https://metallb.github.io/metallb

helm template community-charts community-charts \
--repo https://community-charts.github.io/helm-charts\
--version 1.15.9 \
--namespace n8n \
> ./apps/n8n/base/n8n-1.112.4.yaml




kubectl logs service/ingress-nginx-controller -n ingress-nginx

<!-- CERT MANAGER -->

<!-- CURL LINK -->
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml


https://metallb.io/



self signed cert
https://github.com/antonputra/tutorials/blob/main/lessons/083/example-1/1-ca-certificate.yaml


KA-F:
0-
1-(trzeba zefiniować ten sam namespace co issuer.  Certificatewazne dodać typ pod nazwą issuera do kórego sie odwojemy)

kubectl describe certificate self-signed-cert -n cert-manager



