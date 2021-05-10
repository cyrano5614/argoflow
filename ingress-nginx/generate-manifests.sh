#!/bin/bash

VERSION="${VERSION:-3.30.0}"
REPO="ingress-nginx"
CHART="ingress-nginx"
NAMESPACE="ingress-nginx"

helm -n $NAMESPACE template $CHART $REPO/$CHART \
    --version=$VERSION \
    --set defaultBackend.enabled=true \
    --set controller.publishService.enabled=true \
    --create-namespace > all.yaml
