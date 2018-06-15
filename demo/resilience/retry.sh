#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh


desc "Let's simulate some issues with v2 deployment. Using Istio, let's inject periodic faults into v2"
run "istioctl replace -f $(relative istio/recommendation-service-fault.yml) -n tutorial"

desc "Now, let's add a Retry policy for our service to smooth out the errors"
run "istioctl create -f $(relative istio/preference-service-retry.yml) -n tutorial"

desc "Clean up/restore -- will come back to retries"

run "istioctl delete virtualservice preference -n tutorial"
run "istioctl replace -f $(relative istio/recommendation-service-v1-v2-50-50.yml)"

