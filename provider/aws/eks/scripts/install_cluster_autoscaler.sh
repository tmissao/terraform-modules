echo "#########################################################################################"
echo "#                       Stating Installing CA                                           #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_CA};

if [[ $SHOULD_RUN -eq 1 ]]; then
  NAMESPACE=${CA_NAMESPACE}
  FILTER_NAMESPACE=$(kubectl get namespace | awk -v target=$NAMESPACE 'FNR > 1  {if ($1 == target) print $1}');
  
  if [[ -z "$FILTER_NAMESPACE" ]]; then
    kubectl create namespace $NAMESPACE;
  fi
  
  echo "===========>  AUTO-SCALER HELM VALUES"
  # https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
  helm repo add stable https://charts.helm.sh/stable
  helm repo update
  echo ${CA_VALUES} | base64 --decode > ./autoscaller-values.yaml
  helm install stable/cluster-autoscaler --values=./autoscaller-values.yaml -n $NAMESPACE --name-template cluster-auto-scaler
else 
  echo "should not install Cluster AutoScaler"
fi

echo "#########################################################################################"
echo "#                     FINISHING Installing HPA                                          #"
echo "#########################################################################################"