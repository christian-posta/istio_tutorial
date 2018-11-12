#!/bin/bash

kubectl delete routerules --all
kubectl delete destinationpolicy --all

# for v1alpha3
kubectl delete virtualservice recommendation
kubectl delete virtualservice preference
kubectl delete destinationrule --all