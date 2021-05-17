#!/bin/bash

CLIENTID=$1
CLIENTSECRETS=$2
CLIENTCALLBACK=$3
NAMESPACE="${NAMESPACE:-auth}"
SECRETNAME="${SECRETNAME:-dex-github-secret}"

if [[ -z "$CLIENTID" ]] || [[ -z "$CLIENTSECRETS" ]] || [[ -z "$CLIENTCALLBACK" ]]; then
    echo "Must provide CLIENTID, CLIENTSECRETS, CLIENTCALLBACK" 1>&2
    exit 1
fi

kubectl -n $NAMESPACE create secret generic $SECRETNAME --dry-run=client --from-literal=CLIENT_ID=$CLIENTID --from-literal=CLIENT_SECRETS=$CLIENTSECRETS --from-literal=CLIENT_CALLBACK=$CLIENTCALLBACK -o json > exposed-secrets.json

kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets <exposed-secrets.json >sealed-secrets.json
