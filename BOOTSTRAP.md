Bootstrapping an ArgoCD Agent Autonomous mode hub cluster:

Note the use of `ocp-sno.lab.home` as a domain, change or template as needed.

Deploy gitops operator from `subscription.yaml`
Deploy cert-manager operator from `cert-manager/`
Deploy "principal"/hub ArgoCD instance and agent from `argocd-agent-principal/`
- Includes one-time issuers and certificates

Add "hub's spoke" registration resources to principal ArgoCD from `argocd-agent-registration`:
- Note the "hub's spoke" is called `argocd-agent-hub` here but will be called `argocd-agent-<cluster-name>` in target environment
- Again template hub's spoke name and base domain (here ocp-sno.lab.home)
- `argocd-agent-register.yaml` contains identity resources for "hub's spoke" in the hub namespace
- `argocd-agent-cluster-secret.sh` (note derivation from .yaml) is a templated resource that transforms the argocd-principal-hub cert to the spoke

Add "hub's spoke" Argo instance from `argocd-agent`:
- Creates namespace `argocd-agent` and included resources
- Some resources again as `.sh` files, these transfrom resources from generated certs
- Again everywhere you see "argocd-agent-hub" that needs to be "argocd-agent-<cluster-name>"
- Same with base domain "ocp-sno.lab.home"
- values.yaml included for reference (it generates the rendered `argocd-agent-chart.yaml`) but do not deploy the values file.  This was generated from (but do not need to rerun!):
```
helm template --kube-version "v1.33.6" argocd-agent redhat-argocd-agent --repo https://charts.openshift.io/ --values values.yaml -n argocd-agent --set fullnameOverride=argocd-agent > argocd-agent-chart.yaml
```
