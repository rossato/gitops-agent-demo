#!/bin/bash

RESULT=`oc get secret -n argocd argocd-agent-hub -o json`

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-agent-client-tls
  namespace: argocd-agent
type: kubernetes.io/tls
data:
  ca.crt: `echo $RESULT |jq '.data."ca.crt"'`
  tls.crt: `echo $RESULT |jq '.data."tls.crt"'`
  tls.key: `echo $RESULT |jq '.data."tls.key"'`
EOF
