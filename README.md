### Set up Elastic stack - Elasticsearch - FluentD - Kibana on AWS EKS cluster 

[![Screenshot-2022-12-23-at-17-32-31.png](https://i.postimg.cc/nzrjYv6Z/Screenshot-2022-12-23-at-17-32-31.png)](https://postimg.cc/dkMVJTsS)

<!-- MySQL => Databases => Tables => Rows/Columns
Elasticsearch => Indices(Index) => Types => Documents with Field -->
<!-- 
https://www.elastic.co/blog/what-is-an-elasticsearch-index -->

<!-- DB -- Index
Table -- Type
Row -- Documents
Column -- Fields -->

<!-- https://www.velotio.com/engineering-blog/elasticsearch-101-fundamentals-core-concepts#:~:text=Elasticsearch%20(ES)%20is%20a%20combination,capabilities%20with%20simple%20REST%20APIs. -->

<!-- https://www.elastic.co/guide/en/elasticsearch/reference/current/_mapping_concepts_across_sql_and_elasticsearch.html -->

#### Create Docker Images from Source Code

We will create 2 basic Docker images ,then we will push them to AWS ECR and deploy them to AWS EKS. Both application will produce logs with JSON format ,so we will catch it via Fluentd and send it to ElasticSearch engine in EKS.

```
zhajili$ docker images | grep app
java-app                                1.0               fe24516925bb   24 seconds ago   103MB
node-app                                1.0               1b36baaa2031   8 minutes ago    114MB

```

#### Upload Docker Images to AWS ECR

For Docker to push the image to ECR, first we have to authenticate our Docker credentials with AWS. We use the get-login-password command that retrieves and displays an authentication token using the GetAuthorizationToken API that we can use to authenticate to an Amazon ECR registry.

```
zhajili$  aws ecr --region us-east-1 | docker login -u AWS -p eyJwYXlsb2FkIjoibUMyaDdPMjlwRU9SRmRDNk1XUzM2NTYrM2t4SFJuN3QxTkhkOVFJdXFTVS81ZkMxaFBRTDJzKzZIcExqTFpsREtBS2lNTk83WW4xN1BkdGw2WGFHT3hTZW42NTI4dGZyN3c0VjZjS0NGNmppRERrSEwwaWkrMThicTZhNWc0L21NTGNqUFFhWWREbjJhWmxXQWp6TEtxbGFqMEk1clVya3dnTFhWWHZmT0VvTTdVZW9yTVExSDhiRHd6emZKK3AzUzh5MDdhRFZvcUFZVVBIUUlDY2hxN3N3cnArSld2RGMvb1M3OVh0aHkrYXFqQytRblZWRituS1RxTUFaeTljUHRac2VBWUVock9xOXRGaGNUREVHOFlHRlpLYk5EaDk4OU8xZy83cUkveXIrTHF6c0kyWWlXNkRHMjNwVzVlM083ZEVMWkNDblNwMWhZbVQvbFRxbG0ySzJKTmRqREpzN2VnVmNyYmpVQWF1YTExR1dxaTB3LzBMSjEvY0Z0VFN0cmU3Yy9XSEwreThWdHV5Q1RncCt2bW5KbjdPUnNUQU5OQ3VCUnVsVGhZSHBzZ2svOUM4SXVHZ2NCdXNKc0haVHNIRHRMOGhmZ2JLZkI1bHNMN0gwM3VoR1hqR0g5Qkwza04vN0gyM0l5Q0RzQ1NvSzhuZUxNNXBlcm9lV2VocjVBVDRCaE4wVTNnNkhuRm9VeUM0ZXJkNnhiUzE5K1lPVStiR0M5NE5pYUVyWTdrOTRSanphOEdOc09UUmhvbXdFR1JnODVaeUROZ0c3WlNzUU1menZxSlAxc0I0VVcvQ2dpMk1LYXR0eHUrVURPMFdjYjNQNjJwTUtRMUE5RTV4Q1d3ZURjRjU3bkZPalRvRmxPVFczcmVIRi9lNDFIaExKYkh2QlVOYzRVdEVVUy92U2ZSUW5wSzl1Qy9CQWRZVnh2LzZqNHQ4V3pFNlc5UU55MEM2MmhJNFBSRGVOdXpkbzFWeHNRVWxVR3p3L0kvS2NwNVlZZlJDdXlwQysydm9FcmR1NGxLSHlMaldDb1p3RFVxRFV1VlVrTlhTUnhLM0F5QmVxR25SeDEvcTQzRzBjVGxQSmNwOFBuaTd2RHRoNVlsM3VPQzk1OVFIL21rUkExK3c2eVlNdFY5OU1EZW0wYlF1WWRvQ0RhSXZzQy84TjQ3QnpEaW9Fd3ZNRHQyKzYwSVBZSGFTSlVMbkVlWnRXRDAzQk1FVVdSaGNlUEtEaUVWMEttT2V1MHlaWGxnbU5XVFR5cythM3U1TGdHWGIzcXh5eTBwVzJHR3Nhc3U4emMwN1Q5Mkd4SmRTSGlYZ25kV2xONDdKNStkOVBsNmttenB2NEhkTys5QzVjbzMxY2k5dXVMeVMrVTBWMWtmMWNRenNVZGgwL2h2RXlDYkhFUXc9PSIsImRhdGFrZXkiOiJBUUVCQUhod20wWWFJU0plUnRKbTVuMUc2dXFlZWtYdW9YWFBlNVVGY2U5UnE4LzE0d0FBQUg0d2ZBWUpLb1pJaHZjTkFRY0dvRzh3YlFJQkFEQm9CZ2txaGtpRzl3MEJCd0V3SGdZSllJWklBV1VEQkFFdU1CRUVETTRwM2twT0hTc0JNMU5FY2dJQkVJQTdsTWNxTmtTdHl4VjA5UjdMbUR6N3BxeDlsRnRuc0NZR3A1ZkRpOFZieWE5OGk5RnV1YWh6V1E1QVJTNFhqc2hlSTMyQWdMM05jVTNyVGpVPSIsInZlcnNpb24iOiIyIiwidHlwZSI6IkRBVEFfS0VZIiwiZXhwaXJhdGlvbiI6MTY3MTk2Nzc0M30= 866308211434.dkr.ecr.us-east-1.amazonaws.com/docker_images_for_elk_stack
WARNING! Using --password via the CLI is insecure. Use --password-stdin.

usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
To see help text, you can run:

  aws help
  aws <command> help
  aws <command> <subcommand> help

aws: error: the following arguments are required: operation

Login Succeeded

```
After successfull login we will tag our local docker images via following command 

```
docker tag <source_image_tag> <target_ecr_repo_uri>

```
After tagging we will push our docker images to respective ECR repositories.Please note that I have created 2 different repositories for each docker image manually.

```
zhajili$ docker tag node-app:1.0 866308211434.dkr.ecr.us-east-1.amazonaws.com/node-js:1.0
zhajili$ docker tag java-app:1.0 866308211434.dkr.ecr.us-east-1.amazonaws.com/java-app:1.0
zhajili$ docker push 866308211434.dkr.ecr.us-east-1.amazonaws.com/node-js:1.0
The push refers to repository [866308211434.dkr.ecr.us-east-1.amazonaws.com/node-js]
3d1a1859b42b: Pushed 
391ab2ad6e16: Pushed 
06caedfe5356: Pushed 
54efd5464c2e: Pushed 
629960860aca: Pushed 
f019278bad8b: Pushed 
8ca4f4055a70: Pushed 
3e207b409db3: Pushed 
1.0: digest: sha256:d4dc3ce8a87783f0a2ffd506ebd62b7726599c62a2e4d8048191a8ee95ba1fef size: 1987
zhajili$ docker push 866308211434.dkr.ecr.us-east-1.amazonaws.com/java-app:1.0
The push refers to repository [866308211434.dkr.ecr.us-east-1.amazonaws.com/java-app]
5f70bf18a086: Pushed 
28c5b5a8c01f: Pushed 
edd61588d126: Pushed 
9b9b7f3d56a0: Pushed 
f1b5933fe4b5: Pushed 
1.0: digest: sha256:461e9e52f7c771340827a7e5299fb90d63cb1218e2a8aad6da27efd87bb2d062 size: 1365

```

#### Create AWS EKS cluster via Terraform

We will use terraform to create EKS cluster ,please navigate to Directory Terraform Files and execute **terraform init** command .It will start to download modules for kubernetes as it is stated in **eks-cluster.tf** like below.

```
provider "kubernetes" {
  config_path = "~/.kube/config"
  host = data.aws_eks_cluster.ekl_eks_cluster.endpoint
  token = data.aws_eks_cluster_auth.ekl_eks_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.ekl_eks_cluster.certificate_authority.0.data)
}
```
Let's execute terraform plan see what resources will be created.

```
          + resource_type = "network-interface"
          + tags          = {
              + "Name"        = "worker-group-2"
              + "application" = "EKS-STACK"
              + "environment" = "development"
            }
        }
      + tag_specifications {
          + resource_type = "volume"
          + tags          = {
              + "Name"        = "worker-group-2"
              + "application" = "EKS-STACK"
              + "environment" = "development"
            }
        }
    }

  # module.eks.module.self_managed_node_group["two"].aws_security_group.this[0] will be created
  + resource "aws_security_group" "this" {
      + arn                    = (known after apply)
      + description            = "Self managed node group security group"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = "worker-group-2-node-group-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name"        = "worker-group-2-node-group"
          + "application" = "EKS-STACK"
          + "environment" = "development"
        }
      + tags_all               = {
          + "Name"        = "worker-group-2-node-group"
          + "application" = "EKS-STACK"
          + "environment" = "development"
        }
      + vpc_id                 = (known after apply)
    }

Plan: 72 to add, 0 to change, 0 to destroy.

```

The output is long hence it is omitted ,as as summary we can see that 72 resources will be created. It will take around 15 minutes to complete to create our EKS cluster.Our kubernetes version is 1.22 and 3 Self-Managed worker nodes will be created.

```
Apply complete! Resources: 72 added, 0 changed, 0 destroyed.

```
[![Screenshot-2022-12-25-at-01-40-21.png](https://i.postimg.cc/4dPJnxck/Screenshot-2022-12-25-at-01-40-21.png)](https://postimg.cc/gXw9Td4N)

[![Screenshot-2022-12-25-at-01-42-09.png](https://i.postimg.cc/Kvwm1V1z/Screenshot-2022-12-25-at-01-42-09.png)](https://postimg.cc/kBQ0ZTF3)
Let's do some verification after finishing installation.

First of all ,we will need to update kubeconfig in order to manage our EKS cluster with following command.

```
aws eks update-kubeconfig --name EKL-stack-cluster

```
We can see that EKL-stack-cluster details has been added to ~/.kube/config.

```
zhajili$ cat ~/.kube/config | grep EKL
  name: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
    cluster: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
    user: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
  name: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
current-context: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
- name: arn:aws:eks:us-east-1:866308211434:cluster/EKL-stack-cluster
      - EKL-stack-cluster

```
And we can reach and manage to our worker nodes ,remember that all our worker nodes are actually EC2 instances which are managed by us due to configuring Self-Managed Worker Nodes.

```
zhajili$ kubectl get nodes
NAME                           STATUS   ROLES    AGE   VERSION
ip-10-20-10-88.ec2.internal    Ready    <none>   18m   v1.22.15-eks-fb459a0
ip-10-20-20-242.ec2.internal   Ready    <none>   18m   v1.22.15-eks-fb459a0
ip-10-20-20-50.ec2.internal    Ready    <none>   17m   v1.22.15-eks-fb459a0
ip-10-20-30-76.ec2.internal    Ready    <none>   17m   v1.22.15-eks-fb459a0

```
Now let's execute following command in each subdirectory for creating our first deployment for each application.

```
kubectl apply -f deployment.yaml 

```
Our deployments have been created and totally 7 PODS are running 

```
zhajili$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
java-app-7445d5847f-dd5bd   1/1     Running   0          9m4s
java-app-7445d5847f-m7ppz   1/1     Running   0          9m4s
java-app-7445d5847f-tbq2z   1/1     Running   0          9m4s
node-app-96cd64687-28vgg    1/1     Running   0          13s
node-app-96cd64687-86qht    1/1     Running   0          15s
node-app-96cd64687-qgbh8    1/1     Running   0          15s
node-app-96cd64687-szlv4    1/1     Running   0          13s
```
We can use also [Lens](https://k8slens.dev/) and check our further deployments ,Services ,ReplicaSets ,ConfigMaps ,Secrets and etc .Kubernetes Lens Extensions allows you to add new and custom features and visualizations to accelerate development workflows for all the technologies and services that integrate with Kubernetes. 

[![Screenshot-2022-12-25-at-02-49-50.png](https://i.postimg.cc/Z5ckmMz0/Screenshot-2022-12-25-at-02-49-50.png)](https://postimg.cc/ZWCsFjRh)

#### Deploy ElasticSearch with Helm Chart 

Before installing Helm Chart ,please be remember to add inbound TCP port 9200 and port 9300 and outbound 0.0.0.0 to Security Group of Worker Nodes 

Let's start deploy our ElasticSearch and see result.

```
    helm repo add elastic https://Helm.elastic.co
    helm install elasticsearch elastic/elasticsearch -f value-elasticsearch.yaml
```
I have changed Java Heapsize to 750 mb ,since it was giving resource error and it seems that default value is not enough.
I have also added PVC in order to have persistent Volume to keep all database in case any crash.

After some time ,let's check pods in elasticsearch namespace.

```
zhajili$ kubectl get all -n elasticsearch
NAME                         READY   STATUS    RESTARTS   AGE
pod/elasticsearch-master-0   1/1     Running   0          3m42s
pod/elasticsearch-master-1   1/1     Running   0          3m42s
pod/elasticsearch-master-2   1/1     Running   0          3m42s

NAME                                    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)             AGE
service/elasticsearch-master            ClusterIP   172.20.34.6   <none>        9200/TCP,9300/TCP   3m42s
service/elasticsearch-master-headless   ClusterIP   None          <none>        9200/TCP,9300/TCP   3m42s

NAME                                    READY   AGE
statefulset.apps/elasticsearch-master   3/3     3m43s

```
As we can see ElasticSearch Pods are stateful.

Let's verify healthcheck via CURL

curl -X GET "https://localhost:9200/_cluster/health?pretty"

{
  "cluster_name" : "elasticsearch",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 1,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```
zhajili$ kubectl get pods -n elasticsearch
NAME                        READY   STATUS    RESTARTS   AGE
elasticsearch-master-0      1/1     Running   0          8m53s
elasticsearch-master-1      1/1     Running   0          8m53s
elasticsearch-master-2      1/1     Running   0          8m53s
java-app-7445d5847f-84wtm   1/1     Running   0          69s
java-app-7445d5847f-bn744   1/1     Running   0          69s
java-app-7445d5847f-fpxcr   1/1     Running   0          69s
java-app-7445d5847f-h6mpw   1/1     Running   0          69s
java-app-7445d5847f-rgwbt   1/1     Running   0          69s
java-app-7445d5847f-tjjpq   1/1     Running   0          69s
java-app-7445d5847f-z6glg   1/1     Running   0          69s
node-app-96cd64687-8pwcs    1/1     Running   0          58s
node-app-96cd64687-n8cll    1/1     Running   0          58s
node-app-96cd64687-q5tkz    1/1     Running   0          58s
node-app-96cd64687-r4pd6    1/1     Running   0          58s

```
#### Deploy Kibana with Helm Chart 

Make sure to open TCP port 5601 on Security Group for Worker Nodes and apply following command in elasticsearch namespace.

```
helm install kibana elastic/kibana -n elasticsearch

zhajili$ kubectl get pods -n elasticsearch
NAME                             READY   STATUS    RESTARTS   AGE
elasticsearch-master-0           1/1     Running   0          24m
elasticsearch-master-1           1/1     Running   0          24m
elasticsearch-master-2           1/1     Running   0          24m
java-app-7445d5847f-84wtm        1/1     Running   0          16m
java-app-7445d5847f-bn744        1/1     Running   0          16m
java-app-7445d5847f-fpxcr        1/1     Running   0          16m
java-app-7445d5847f-h6mpw        1/1     Running   0          16m
java-app-7445d5847f-rgwbt        1/1     Running   0          16m
java-app-7445d5847f-tjjpq        1/1     Running   0          16m
java-app-7445d5847f-z6glg        1/1     Running   0          16m
kibana-kibana-769dfd4cdf-2xn7j   1/1     Running   0          5m4s

```

```
zhajili$ kubectl get service --all-namespaces
NAMESPACE       NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
default         kubernetes                      ClusterIP   172.20.0.1       <none>        443/TCP             116m
elasticsearch   elasticsearch-master            ClusterIP   172.20.34.6      <none>        9200/TCP,9300/TCP   29m
elasticsearch   elasticsearch-master-headless   ClusterIP   None             <none>        9200/TCP,9300/TCP   29m
elasticsearch   kibana-kibana                   ClusterIP   172.20.185.150   <none>        5601/TCP            10m
kube-system     kube-dns                        ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP       116m
```
We can see that TYPE is **ClusterIP** ,so it means we will not able to reach it from outside ,we will install Ingress for Load Balancing later to achieve it ,for now we can use port forwarding via following command from localhost.

```
zhajili$ kubectl port-forward deployment/kibana-kibana 5601 -n elasticsearch 
Forwarding from 127.0.0.1:5601 -> 5601
Forwarding from [::1]:5601 -> 5601

```

[![Screenshot-2022-12-25-at-22-44-40.png](https://i.postimg.cc/ZngGhYkg/Screenshot-2022-12-25-at-22-44-40.png)](https://postimg.cc/y3mQmH8X)

#### Deploy Ingress Controller for Kibana Access

Ingreess Controller will route external traffic to the Kibana server which is terminated with Cluster IP.Initial request will come to the Cloud Provider's load balancer.It will be logically in front of Ingress Controller.

```
helm install nginx-ingress ingress-nginx/ingress-nginx -n elk-stack

```
#### Deploy FluentD via HelmChart

We will use again HelmChart to install Fluentd with following commands

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install fluentd bitnami/fluentd -n ekl-stack
```

```
zhajili$ kubectl get pods -n ekl-stack
fluentd-652nd                                             1/1     Running   4 (3m25s ago)   4m13s
fluentd-69vqk                                             1/1     Running   4 (3m11s ago)   4m13s
fluentd-6n6q8                                             1/1     Running   4 (3m13s ago)   4m13s
fluentd-drtrg                                             1/1     Running   4 (3m17s ago)   4m13s

```

I will add update following piece of code to the ConfigMaps> fluentd-forwarder-cm of data section.

```
<source>
  @type tail
  path /var/log/containers/*.log
  # exclude Fluentd logs
  exclude_path /var/log/containers/*fluentd*.log
  pos_file /opt/bitnami/fluentd/logs/buffers/fluentd-docker.pos
  tag kubernetes.*
  read_from_head true
  format json
</source>

```
Before change it was regex expression ,but we will need Json format.
