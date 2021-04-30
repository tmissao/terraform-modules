echo "#########################################################################################"
echo "#              Stating Installing Custom Metrics CloudWatch                             #"
echo "#########################################################################################"

SHOULD_RUN=${INSTALL_CUSTOM_METRICS_CLOUDWATCH};

if [[ $SHOULD_RUN -eq 1 ]]; then
  echo ${CUSTOM_METRICS_CLOUDWATCH_DEPLOYMENT} | base64 --decode > ./custom_metrics_cloudwatch.yaml
  kubectl apply -f ./custom_metrics_cloudwatch.yaml
else 
  echo "should not install CloudWatch Custom Metrics"
fi

echo "#########################################################################################"
echo "#             Finishing Installing Custom Metrics CloudWatch                            #"
echo "#########################################################################################"