#!/bin/zsh
 echo "Bash version ${BASH_VERSION}..."
 for i in {0..10..1}
    do
       kubectl config set-context tp$i --cluster=minikube --user=minikube --namespace=tp$i
 done
