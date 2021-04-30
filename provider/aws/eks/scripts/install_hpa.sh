echo "#########################################################################################"
echo "#                       Stating Installing HPA                                          #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_HPA};

if [[ $SHOULD_RUN -eq 1 ]]; then 
  NAMESPACE=${HPA_NAMESPACE}
  FILTER_NAMESPACE=$(kubectl get namespace | awk -v target=$NAMESPACE 'FNR > 1  {if ($1 == target) print $1}');

  if [[ -z "$FILTER_NAMESPACE" ]]; then
    kubectl create namespace $NAMESPACE;
  fi

  echo "===========>  Configuring Plugin Metrics Server"
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  echo ${HPA_VALUES} | base64 --decode > ./hpa-values.yaml
  helm upgrade metrics-server --install bitnami/metrics-server -n $NAMESPACE --values ./hpa-values.yaml

  echo "===========>  Finished Plugin Metrics Server"

else
  echo "should not install HPA"
fi

echo "#########################################################################################"
echo "#                     FINISHING Installing HPA                                          #"
echo "#########################################################################################"