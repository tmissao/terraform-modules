echo "#########################################################################################"
echo "#                         STATING INSTALLING FLUENTBIT                                  #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_FLUENTBIT};

if [[ $SHOULD_RUN -eq 1 ]]; then
  echo "===========>  Configuring Logging"
  NAMESPACE=${FLUENTBIT_NAMESPACE};
  FILTER_NAMESPACE=$(kubectl get namespace | awk -v target=$NAMESPACE 'FNR > 1  {if ($1 == target) print $1}');

  if [[ -z "$FILTER_NAMESPACE" ]]; then
    kubectl create namespace $NAMESPACE;
  fi

  echo ${FLUENTBIT_OUTPUT} | base64 --decode > ./fluentbit.yaml

  kubectl apply -f ./fluentbit.yaml
else 
  echo "Should Not Install FLUENTBIT"
fi

echo "#########################################################################################"
echo "#                          FINISHING INSTALLING FLUENTBIT                               #"
echo "#########################################################################################"