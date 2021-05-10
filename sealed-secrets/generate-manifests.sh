#!/bin/bash

VERSION="${VERSION:-1.13.2}"
REPO="sealed-secrets"
CHART="sealed-secrets"

helm template $REPO/$CHART --version=$VERSION --name-template=$CHART --namespace=$CHART > all.yaml
