#!/bin/bash

RESULT=`oc get secret -n argocd argocd-principal-hub -o json`

cat <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: argocd-agent-hub-cluster
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
    argocd-agent.argoproj-labs.io/agent-name: argocd-agent-hub
stringData:
  name: argocd-agent-hub
  server: https://argocd-agent-principal-resource-proxy.argocd.svc.cluster.local:9090?agentName=argocd-agent-hub
  config: |
    {
      "tlsClientConfig": {
          "insecure": false,
          "certData": `echo $RESULT |jq '.data."tls.crt"'`,
          "keyData": `echo $RESULT |jq '.data."tls.key"'`,
          "caData": `echo $RESULT |jq '.data."ca.crt"'`
      }
    }
EOF
