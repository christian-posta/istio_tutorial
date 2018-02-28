#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

# grafana: http://localhost:3000
# kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 


# jaeger: http://localhost:16686
# kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686



SOURCE_DIR=$PWD



desc "So we have v1 of our recommendation service"
run "kubectl get pod"


desc "That v1 is taking some load..."
read -s

# split the screen and run the polling script in bottom script
tmux split-window -v -d -c $SOURCE_DIR
tmux select-pane -t 0
tmux send-keys -t 1 "sh $(relative bin/poll_customer.sh)" C-m


read -s
desc "Let's say we want to deploy a new version of our service, v2"

read -s

desc "we will create a new deployment and inject the Istio sidecar. Let's take a look at what that looks like:"

run "cat $(relative kube/recommendation-v2-deployment.yml)"
run "istioctl kube-inject --debug -f $(relative kube/recommendation-v2-deployment.yml)"

desc "Okay. let's actually create it:"
read -s
run "kubectl apply -f <(istioctl kube-inject --debug -f $(relative kube/recommendation-v2-deployment.yml))"

run "kubectl get pod -w"


backtotop

desc "Woah: we don't want this. We dont want to release this version"
read -s

# show routing?
#
# everything to v1?
desc "Let's route everything to v1"
run "istioctl create -f $(relative istio/route-rule-recommendation-v1.yml)"


desc "Using Istio, let's purposefully balance traffic between v1 and v2"
run "istioctl create -f $(relative istio/route-rule-recommendation-v1_and_v2.yml)"


