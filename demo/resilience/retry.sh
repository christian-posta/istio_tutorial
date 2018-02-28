#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh


desc "Let's simulate some issues with v2 deployment. Using Istio, let's inject periodic faults into v2"
run "istioctl create -f $(relative istio/route-rule-recommendation-503.yml)"

desc "Now, let's add a Retry policy for our service to smooth out the errors"
run "istioctl create -f $(relative istio/route-rule-recommendation-retry.yml)"

desc "clean up"

run "istioctl delete -f $(relative istio/route-rule-recommendation-retry.yml) -n tutorial"
run "istioctl delete -f $(relative istio/route-rule-recommendation-503.yml) -n tutorial"

