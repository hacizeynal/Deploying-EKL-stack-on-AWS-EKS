# aws eks update-kubeconfig --name ekl_stack_cluster
# kubectl create namespace elk-stack
# helm install nginx-ingress ingress-nginx/ingress-nginx -n elk-stack
# kubectl apply -f k8s/ingress.yaml -n elk-stack
# helm install elasticsearch elastic/elasticsearch -f k8s/value-elasticsearch.yaml -n elk-stack
# helm install kibana elastic/kibana -n elk-stack
# helm install fluentd bitnami/fluentd -n elk-stack
# kubectl apply -f k8s/NodeJs/deployment.yaml -n elk-stack
# kubectl apply -f k8s/JavaApp/deployment.yaml -n elk-stack