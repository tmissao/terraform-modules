#!/bin/bash

echo "#########################################################################################"
echo "#                             RUNNING SETUP EKS                                         #"
echo "#########################################################################################"

echo "===========>  Configuring KubeConfig"
aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION}
kubectl get svc
echo "===========>  Finished KubeConfig"

echo "===========>  Deploying AWS AUTH"
echo ${AWS_AUTH} | base64 --decode > ./configMapAwsAuth.yaml
kubectl apply -f ./configMapAwsAuth.yaml
echo "===========>  Finishied AWS AUTH"

echo "#########################################################################################"
echo "#                            RUNNING SETUP EKS                                          #"
echo "#########################################################################################"

