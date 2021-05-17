NAMESPACE=$1
KEYFILENAME=$2

kubectl create secret -n $NAMESPACE generic user-gcp-sa \
  --from-file=user-gcp-sa.json=$KEYFILENAME
