#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

# grafana: http://localhost:3000
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 


# jaeger: http://localhost:16686
# kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686



SOURCE_DIR=$PWD

# first deploy the core services

# oc apply -f <(istioctl kube-inject --debug -f $(relative kube/recommendation-v2-deployment.yml))
# turn off v2 for now
#kubectl scale deploy recommendation-v2 --replicas=0

#oc apply -f <(istioctl kube-inject --debug -f $(relative kube/recommendation-v2-delay-deployment.yml))

# turn off the delay stuff for now
#kubectl scale deploy recommendation-delay-v2 --replicas=0
oc apply -f <(istioctl kube-inject -f $(relative kube/recommendation-v1-deployment.yml))
oc apply -f $(relative kube/recommendation-service.yml)

oc apply -f <(istioctl kube-inject -f $(relative kube/preference-deployment.yml))
oc apply -f $(relative kube/preference-service.yml)

oc apply -f <(istioctl kube-inject -f $(relative kube/customer-deployment.yml))
oc apply -f $(relative kube/customer-service.yml)

oc expose service customer
oc get route






