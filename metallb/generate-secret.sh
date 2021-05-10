#!/bin/bash
# Don't use yet
# Using bitnami's sealed secrets to generate secret for argocd dex connectors
# pending https://github.com/argoproj/argo-cd/issues/3685 to be resolved

CLIENTID=$1
CLIENTSECRETS=$2
CLIENTCALLBACK=$3
NAMESPACE="${NAMESPACE:-argocd}"
SECRETNAME="${SECRETNAME:-argocd-user-github-secret}"

if [[ -z "$CLIENTID" ]] || [[ -z "$CLIENTSECRETS" ]] || [[ -z "$CLIENTCALLBACK" ]]; then
    echo "Must provide CLIENTID, CLIENTSECRETS, CLIENTCALLBACK" 1>&2
    exit 1
fi

echo -n bar | kubectl -n $NAMESPACE create secret generic $SECRETNAME --dry-run=client --from-literal=clientid=$CLIENTID --from-literal=clientsecrets=$CLIENTSECRETS --from-literal=clientcallback=$CLIENTCALLBACK -o json > exposed-secrets.json

kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets <exposed-secrets.json >sealed-secrets.json
