#!/bin/bash

# Then login using kubectl

  token=`curl -k  -d '{"uid":"admin","password":"admin"}' http://master:8101/acs/api/v1/auth/login | grep -Po '(?<="token":)(.*?)(?=})' | sed 's/\(^"\|"$\)//g'`

  kubectl config set-cluster cfc --server=https://master:8001 --insecure-skip-tls-verify=true
  kubectl config set-credentials user --token=$token
  kubectl config set-context cfc --cluster=cfc
  kubectl config set-context cfc --user=user --namespace=default
  kubectl config use-context cfc
