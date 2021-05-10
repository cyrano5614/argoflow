#!/bin/bash
# Don't use yet
# Using bitnami's sealed secrets to generate secret for argocd dex connectors
# pending https://github.com/argoproj/argo-cd/issues/3685 to be resolved

NAMESPACE="${NAMESPACE:-metallb-system}"
SECRETNAME="${SECRETNAME:-memberlist}"

echo -n bar | kubectl -n $NAMESPACE create secret generic $SECRETNAME --dry-run=client --from-literal=secretkey="$(openssl rand -base64 128)" -o json > exposed-secrets.json
kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets <exposed-secrets.json >sealed-secrets.json
