#!/bin/bash

VERSION="${VERSION:-1.1.3}"
REPO="stable"
CHART="nfs-server-provisioner"
NAMESPACE="nfs-server-provisioner"

helm -n $NAMESPACE template $CHART $REPO/$CHART \
    --version=$VERSION \
    --set storageClass.defaultClass=true \
    --set persistence.enabled=true \
    --set persistence.storageClass="-" \
    --set persistence.size=100Gi \
    --set nodeSelector."kubernetes\\.io/hostname"=lauda \
    --create-namespace > all.yaml
