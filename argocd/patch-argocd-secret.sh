#!/bin/bash
# Follow this https://argoproj.github.io/argo-cd/operator-manual/user-management/
# to setup github side credentials and use with the script

CLIENTID=$1
CLIENTSECRET=$2
CLIENTURL=$3

if [[ -z "$CLIENTID" ]] || [[ -z "$CLIENTSECRET" ]] || [[ -z "$CLIENTURL" ]]; then
    echo "Must provide CLIENTID, CLIENTSECRET, CLIENTURL" 1>&2
    exit 1
fi

ENCODEDSECRET=$(echo -ne "$CLIENTSECRET" | base64);
ENCODEDID=$(echo -ne "$CLIENTID" | base64);
ENCODEDURL=$(echo -ne "$CLIENTURL" | base64);

# kubectl -n argocd patch secret argocd-secret --type='json' -p='[{"op" : "add" ,"path" : "/data/dex.github.clientSecret" ,"value" : "'"$ENCODEDSECRET"'"}]' --dry-run=client -o yaml

kubectl -n argocd patch secret argocd-secret --type='json' -p='[{"op" : "add" ,"path" : "/data/dex.github.clientID" ,"value" : "'"$ENCODEDID"'"},{"op" : "add" ,"path" : "/data/dex.github.clientSecret" ,"value" : "'"$ENCODEDSECRET"'"},{"op" : "add" ,"path" : "/data/dex.github.url" ,"value" : "'"$ENCODEDURL"'"}]'
