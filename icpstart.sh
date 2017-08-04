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
  echo "All nodes are running - logging in using kubectl"
  
# Then login using kubectl
  ./icplogin.sh
sleep 40  
# now restart the pods, first calico-node then the rest of the world
  echo "Removing calico-node pods"
  kubectl get pods --namespace kube-system  | grep calico-node | awk '{print $1}' | while read line; do kubectl delete pod $line --namespace kube-system ;done
  sleep 30
  echo "Removing stale pods"
  kubectl get pods --namespace kube-system  | grep -v Running | awk '{print $1}' | grep -v "NAME" | while read line; do kubectl delete pod $line --namespace kube-system ; done

  echo "Waiting for processes to settle"
  sleep 60
  echo "Restarting docker"
  ssh root@master -C "ssh proxy -C \"service docker restart\";ssh worker1 -C \"service docker restart\";ssh worker2 -C \"service docker restart\";service docker restart"
  echo "Waiting for containers to be re-initialized"  
  sleep 30
  echo "Logging back in using kubectl"
  ./icplogin.sh
  sleep 60
  kubectl get pods --namespace kube-system  | grep -v Running | awk '{print $1}' | grep -v "NAME" | while read line; do kubectl delete pod $line --namespace kube-system ; done

  kubectl get pods --namespace kube-system
exit 0
