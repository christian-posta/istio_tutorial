#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh


desc "Let's use Istio's circuit breaking / outlier detection to kick out those misbehaving pods"
read -s

run "istioctl create -f $(relative istio/recommendation_cb_policy_pool_ejection.yml)"

desc "Now we see the offending, delayed service timed out and ejected from the pool"
read -s

desc "but every time it's timed out and evaluted for ejection, it still throws a 503!!!"
read -s
desc "how can we work around this!?"
read -s

desc "easy: just retry!"

run "istioctl create -f $(relative istio/route-rule-recommendation-timeout-retry.yml)"

