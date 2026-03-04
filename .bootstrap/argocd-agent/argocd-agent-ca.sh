#!/bin/bash

RESULT=`oc get secret -n argocd argocd-agent-ca -o json`

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-agent-ca
  namespace: argocd-agent
data:
  tls.crt: `echo $RESULT |jq '.data."tls.crt"'`
EOF
