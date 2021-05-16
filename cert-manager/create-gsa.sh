#!/bin/bash

PROJECT_ID=$1
SA_NAME="${SA_NAME:-dns01-solver}"
K8S_SECRET="${K8S_SECRET:-clouddns-dns01-solver-svc-acct}"
SECRET_NAMESPACE="${SECRET_NAMESPACE:-cert-manager}"

gcloud iam service-accounts create $SA_NAME --display-name $SA_NAME --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com \
   --role roles/dns.admin

gcloud iam service-accounts keys create keys.json \
   --iam-account $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

kubectl -n $SECRET_NAMESPACE create secret generic $K8S_SECRET --dry-run=client --from-file=keys.json -o json > exposed-secrets.json
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets <exposed-secrets.json >sealed-secrets.json

kubectl apply -f sealed-secrets.json

# kubectl -n cert-manager create secret generic clouddns-dns01-solver-svc-acct \
#    --from-file=exposed-secrets.json
