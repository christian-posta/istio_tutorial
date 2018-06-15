#!/bin/bash

kubectl delete routerules --all
kubectl delete destinationpolicy --all

# for v1alpha3
kubectl delete virtualservice --all
kubectl delete destinationrule --all