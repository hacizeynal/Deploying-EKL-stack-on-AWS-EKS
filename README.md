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

