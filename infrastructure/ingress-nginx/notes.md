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

helm template metallb  metallb \
--repo https://metallb.github.io/metallb \
--version 0.15.2 \
--namespace metallb \
> ./apps/metallb/metallb-v015.2.yaml




kubectl logs service/ingress-nginx-controller -n ingress-nginx

<!-- CERT MANAGER -->

<!-- CURL LINK -->
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml


https://metallb.io/





