echo "#########################################################################################"
echo "#                       Stating Installing ISTIO                                        #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_ISTIO};

if [[ $SHOULD_RUN -eq 1 ]]; then 
  NAMESPACE=${ISTIO_NAMESPACE}
  FILTER_NAMESPACE=$(kubectl get namespace | awk -v target=$NAMESPACE 'FNR > 1  {if ($1 == target) print $1}');

  if [[ -z "$FILTER_NAMESPACE" ]]; then
    kubectl create namespace $NAMESPACE;
  fi

  echo "===========>  Downloading Istio"
  mkdir -p "istio"
  cd istio
  curl -sL https://istio.io/downloadIstio | ISTIO_VERSION=1.4.10 sh -
  cd istio*
  echo ${ISTIO_VALUES} | base64 --decode > ./custom-values.yaml
  helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.4.10/charts/
  helm upgrade istio-init --install ./install/kubernetes/helm/istio-init --namespace $NAMESPACE
  kubectl -n $NAMESPACE wait --timeout=600s --for=condition=complete job --all
  helm upgrade istio --install ./install/kubernetes/helm/istio --namespace $NAMESPACE \
      --values ./custom-values.yaml
  cd ../..
  echo "===========>  Finished Istio"

  echo "===========>  Getting LoadBalancer Endpoint"
  external_ip=""
  while [[ -z $external_ip ]]; do
      echo "Waiting for loadbalancer ..."
      external_ip=$(kubectl -n $NAMESPACE get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
      [[ -z "$external_ip" ]] && sleep 10
  done
  echo "Endpoint is ready: $external_ip"
  aws ssm put-parameter --name "eks-${CLUSTER_NAME}-istio-loadbalancer" --value $external_ip --type String --overwrite
  echo "===========>  Finished Getting LoadBalancer Endpoint"
else
  echo "should not install ISTIO"
fi

echo "#########################################################################################"
echo "#                     FINISHING Installing ISTIO                                        #"
echo "#########################################################################################"