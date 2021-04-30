echo "#########################################################################################"
echo "#                       Stating Installing Rancher                                      #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_RANCHER};
DEPLOYMENT_PATH=${RANCHER_DEPLOYMENT_PATH}
SHOULD_ENABLE_MONITORING=${INSTALL_RANCHER_MONITORING};
MONITORING_NAMESPACE=cattle-monitoring-system

if [[ $SHOULD_RUN -eq 1 ]]; then 

  kubectl apply -f $DEPLOYMENT_PATH

  if [[ $SHOULD_ENABLE_MONITORING -eq 1 ]]; then
    echo "===========>  Configuring Monitoring"

    FILTER_NAMESPACE=$(kubectl get namespace | awk -v target=$MONITORING_NAMESPACE 'FNR > 1  {if ($1 == target) print $1}');

    if [[ -z "$FILTER_NAMESPACE" ]]; then
      kubectl create namespace $MONITORING_NAMESPACE;
    fi

    echo ${RANCHER_VOLUMES} | base64 --decode > ./rancher_volumes.yaml
    kubectl apply -f ./rancher_volumes.yaml -n $MONITORING_NAMESPACE
  else 
    echo "should not enable monitoring RANCHER"
  fi

else
  echo "should not install RANCHER"
fi

echo "#########################################################################################"
echo "#                     FINISHING Installing Rancher                                      #"
echo "#########################################################################################"