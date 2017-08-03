#!/bin/bash

# First check all the nodes are up
  while ! ping -q -c1 192.168.138.10 > /dev/null
  do
    echo "waiting for master"
    sleep 10
  done
  while ! ping -q -c1 192.168.138.20 > /dev/null
  do
    echo "waiting for proxy"
    sleep 10
  done
  while ! ping -q -c1 192.168.138.31 > /dev/null
  do
    echo "waiting for worker1"
    sleep 10
  done
  while ! ping -q -c1 192.168.138.32 > /dev/null
  do
    echo "waiting for worker2"
    sleep 10
  done

  
# Then login using kubectl

  token=`curl -k  -d '{"uid":"admin","password":"admin"}' http://master:8101/acs/api/v1/auth/login | grep -Po '(?<="token":)(.*?)(?=})' | sed 's/\(^"\|"$\)//g'`

  kubectl config set-cluster cfc --server=https://master:8001 --insecure-skip-tls-verify=true
  kubectl config set-credentials user --token=$token
  kubectl config set-context cfc --cluster=cfc
  kubectl config set-context cfc --user=user --namespace=default
  kubectl config use-context cfc
  
# now restart the pods, first calico-node then the rest of the world

  kubectl get pods --namespace kube-system  | grep calico-node | awk '{print $1}' | while read line; do kubectl delete $line --namespace kube-system ;done
  sleep 10
  kubectl get pods --namespace kube-system  | grep -v Running | awk '{print $1}' | while read line; do kubectl delete $line --namespace kube-system ;done
  
exit 0