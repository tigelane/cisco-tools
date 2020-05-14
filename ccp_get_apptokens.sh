#!/bin/bash
VERSION=2

# Make sure the user passed us the kubeconfig file
if [ "$1" == "" ] || [ $# -gt 1 ]; then
        echo "Please pass us the kubeconfig.yaml file."
        echo "Example $0 demo1-kubeconfig.yaml"
        exit 0
fi

# Gather information about the ingress controller for use in creating URLs:
URLBASE=`kubectl get -A services --kubeconfig=demo1-kubeconfig.yaml | grep nginx-ingress-controller | awk '{print $5}'`

# Gather information for Kubernetes Dashboard
DSECRET=`kubectl get secrets -n kube-system --kubeconfig=$1 | grep default | awk '{print $1}'`
echo "$DSECRET"
DTOKEN=`kubectl describe secret $DSECRET -n kube-system --kubeconfig=$1 | grep token: | awk '{print $2}'`
# Print information for Kubernetes Dashboard
echo ""
echo "==Kubernetes Dashboard=="
echo "URL: https://$URLBASE/dashboard/"
echo "Token: $DTOKEN"

# Gather information for Grafana
GSECRET=`kubectl get secrets/ccp-monitor-grafana -n ccp -o yaml --kubeconfig=$1`
GUSERNAME=`echo $GSECRET | grep admin-password: | awk '{print $5}' | base64 -D`
GTOKEN=`echo $GSECRET | grep admin-password: | awk '{print $7}' | base64 -D`
# Print information for Grafana
echo ""
echo "==Grafana=="
echo "URL: https://$URLBASE/grafana/"
echo "Username: $GUSERNAME"
echo "Password: $GTOKEN"
