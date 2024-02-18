# visual-anomaly bundle core-versions target deployment docker compose directory

# Table of Contents
1. [Introduction](#intro)
2. [Prerequisites](#prerequisites)
3. [Services](#services)
    1. [Model download](#model_download)
        1. [Configuration](#model_download_conf)
        2. [Credentials](#model_download_creds)
    2. [Model serving](#serving)
        1. [Configuration](#serving_conf)
            1. [Model resources](#serving_conf_res)
            2. [Tensorflow options](#serving_conf_tf)
        2. [Credentials](#serving_creds)
    3. [Nginx router](#nginx)
        1. [Configuration](#nginx_conf)
        2. [Credentials](#nginx_creds)
    4. [Model proxy](#model_proxy)
        1. [Configuration](#model_proxy_conf)
        2. [Credentials](#model_proxy_creds)
4. [How to deploy](#deploy)

## Introduction <div id='intro'>
Bundle consists of 4+ services: model_proxy, visual-anomaly-nginx router, model_download and as many s<model_id>s services as there are models in the bundle.
The default setup is defined in /base.

/base and /example directory must not be edited, they are generated anew each time a bundle event happens (new model, new bundle-state created).

The setup for a real deployment is shown in /example. All the services defined in /base are [included](https://docs.docker.com/compose/multiple-compose-files/include/) in /example/docker-compose.yaml -> to start the whole stack in a single network, `docker compose -f /example/docker-compose.yaml up -d` is enough.

To configure /base services using /example dir, /example/conf/bundle and /example/creds/bundle dirs are added, there you can add configuration files for each service and credentials for each service.
If the exposed env vars are not enough and you still want to override /base services, you can do so by editing files in base, but note that base is regenerated with each bundle update, so you will need to keep track of edits you made in your deployment machines /base dir.
Since creds and conf are loaded outside the /base directory, /example/.env file needs to be added. Inside there should be an env variable with the full path to the /example directory on the target server. (see /example/.env)

Server prerequisites and configuration options for each service will be described in the following sections.


## Prerequisites <div id='prerequisites'>

* docker engine >= 20.10.5
* docker compose >= 2.22.0
* docker registry credentials (permission to pull from eu.gcr.io/microblink-identity)
* gcloud service account for a bucket where encrypted models will be stored

## Services <div id='services'> 

The configuration files shown in examples are all generated in /example/bundle/conf, so the easiest way to **configure your deployment** is to copy and rename /example to /<deployment_dir>, edit the files as needed, and run docker compose from the copied directory.

Here's a list of services with their configuration options and credentials you need to provide for each:

### model_download <div id='model_download'>

Downloads models from a bucket and stores them in /base/model-serving/model-download/models directory.
Exits after downloading all models.

#### Configuration <div id='model_download_conf'>

Not needed for model_download

#### Credentials <div id='model_download_creds'>

To enable model download, you need to provide credentials for the bucket where models are stored. 
Google Cloud and S3 buckets are supported.

If your models are stored on gcs, the [service account](https://cloud.google.com/iam/docs/service-accounts-create) credentials must be in /<deployment_dir>/creds/bundle/gcs.json file: 
```
{
    "type": "string",
    "project_id": "string",
    "private_key_id": "uid",
    "private_key": "private-key",
    "client_email": "email",
    "client_id": "int",
    "auth_uri": "url",
    "token_uri": "url",
    "auth_provider_x509_cert_url": "url",
    "client_x509_cert_url": "url",
    "universe_domain": "domain"
}
```
If your models are stored on s3, the credentials must be in  /<deployment_dir>/creds/bundle/.env, with the following values:
```
RCLONE_S3_PROVIDER=<minio | s3>
RCLONE_S3_ACCESS_KEY_ID=<access_key_id>
RCLONE_S3_SECRET_ACCESS_KEY=<secret_access_key>
RCLONE_S3_ENDPOINT=<endpoint_without_protocol>
```

### s<model_id>s (model-serving) <div id='serving'>

Runs model serving for each model in the bundle, longrunning service.
Depending on the model, it can be [tensorflow serving](https://www.tensorflow.org/tfx/guide/serving) or [triton inference server](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/index.html).

#### Configuration <div id='serving_conf'>

##### model resources <div id='serving_conf_res'>

To configure **cpu** and **memory** model resources, you can edit .env file in /<deployment_dir>/bundle/conf directory, with the following env variables:
```
SERVING_<model_id>_CPU_LIMIT=<int_value>
SERVING_<model_id>_MEM_LIMIT=<string_value>
SERVING_<model_id>_CPU_RESERVATION=<int_value>
SERVING_<model_id>_MEM_RESERVATION=<string_value>
```
where <model_id> is the model registry model id.
If your serving image is using **gpu**, it will use all gpu devices when started. If you want to limit the number of gpu devices used for a serving service s<model_id>s, you will need to edit /base/bundle/docker-compose.yaml service section.
The following example restricts gpu usage to one device, by uncommenting the lines shown in green:
``` diff
  s<model_id>s:
    depends_on:
      model_download:
        condition: service_completed_successfully
    image: <image>
    networks:
      - <network>
    volumes:
      - <volumes>
    command: [<cmd>]
    deploy:
      resources:
        limits:
          cpus:  ${SERVING_<model_id>_CPU_LIMIT}
          memory: ${SERVING_<model_id>_MEM_LIMIT}
        reservations:
          cpus: ${SERVING_<model_id>_CPU_RESERVATION}
          memory: ${SERVING_<model_id>_MEM_RESERVATION}
>         #devices:
>           #- capabilities: [gpu]
>             #count: 1
```

#### tensorflow serving <div id='serving_conf_tf'>

To configure **batching options** for tensorflow serving, a batching_<model_id>.txt with placeholders needs to be [edited](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/batching/README.md#batch-scheduling-parameters-and-tuning) as needed in /<deployment_dir>/bundle/conf, and this file needs to be made available to the s<model_id>s service by editing /base/bundle/docker-compose.yaml service section.
The following example shows the green lines that you need to uncomment in /base/bundle/docker-compose.yaml to enable batching for service s<model_id>s:
``` diff
  s<model_id>s:
    depends_on:
      model_download:
        condition: service_completed_successfully
    image: <image>
    networks:
      - <network>
    volumes:
>     #- ${REL_DIR}/conf/bundle/batching_<model_id>.txt:/etc/batching.txt
      #- ./monitoring.txt:/etc/monitoring.txt
    command:
      - --enable_model_warmup
      - --model_name=<model_id>
      - --model_base_path=/models/<model_id>

      #- --tensorflow_inter_op_parallelism=<int_val>
      #- --tensorflow_intra_op_parallelism=<int_val>
      
>     #- --enable_batching
>     #- --batching_parameters_file=/etc/batching.txt

      #- --monitoring_config_file=/etc/monitoring.txt

      #- --grpc_max_threads=<int_val>
      ...
```

To configure **monitoring** for tensorflow serving, you need to edit /base/bundle/docker-compose.yaml service section.
The following example shows the green lines that you need to uncomment in /base/bundle/docker-compose.yaml to enable monitoring for service s<model_id>s:
``` diff
  s<model_id>s:
    depends_on:
      model_download:
        condition: service_completed_successfully
    image: <image>
    networks:
      - <network>
    volumes:
      #- ${REL_DIR}/conf/bundle/batching_<model_id>.txt:/etc/batching.txt
>     #- ./monitoring.txt:/etc/monitoring.txt
    command:
      - --enable_model_warmup
      - --model_name=<model_id>
      - --model_base_path=/models/<model_id>

      #- --tensorflow_inter_op_parallelism=<int_val>
      #- --tensorflow_intra_op_parallelism=<int_val>
      
      #- --enable_batching
      #- --batching_parameters_file=/etc/batching.txt

>     #- --monitoring_config_file=/etc/monitoring.txt

      #- --grpc_max_threads=<int_val>
      ...
```

To configure **parallelism ops**, you need to edit /base/bundle/docker-compose.yaml service section.
The following example shows the green lines that you need to uncomment and edit in /base/bundle/docker-compose.yaml to enable inter and intra ops for service s<model_id>s:
``` diff
  s<model_id>s:
    depends_on:
      model_download:
        condition: service_completed_successfully
    image: <image>
    networks:
      - <network>
    volumes:
      #- ${REL_DIR}/conf/bundle/batching_<model_id>.txt:/etc/batching.txt
      #- ./monitoring.txt:/etc/monitoring.txt
    command:
      - --enable_model_warmup
      - --model_name=<model_id>
      - --model_base_path=/models/<model_id>

>     #- --tensorflow_inter_op_parallelism=<int_val>
>     #- --tensorflow_intra_op_parallelism=<int_val>
      
      #- --enable_batching
      #- --batching_parameters_file=/etc/batching.txt

      #- --monitoring_config_file=/etc/monitoring.txt

      #- --grpc_max_threads=<int_val>
      ...
```

To configure the max grpc server threads to handle grpc messages (default value is grpc_max_threads = 4.0 * port::NumSchedulableCPUs()), you need to edit /base/bundle/docker-compose.yaml service section. If grpc_max_threads is not properly set, you could get StatusCode.RESOURCE_EXHAUSTED errors from tf serving.
The following example shows the green lines that you need to uncomment and edit in /base/bundle/docker-compose.yaml to configure this for service s<model_id>s:
``` diff
  s<model_id>s:
    depends_on:
      model_download:
        condition: service_completed_successfully
    image: <image>
    networks:
      - <network>
    volumes:
      #- ${REL_DIR}/conf/bundle/batching_<model_id>.txt:/etc/batching.txt
      #- ./monitoring.txt:/etc/monitoring.txt
    command:
      - --enable_model_warmup
      - --model_name=<model_id>
      - --model_base_path=/models/<model_id>

      #- --tensorflow_inter_op_parallelism=<int_val>
      #- --tensorflow_intra_op_parallelism=<int_val>
      
      #- --enable_batching
      #- --batching_parameters_file=/etc/batching.txt

      #- --monitoring_config_file=/etc/monitoring.txt

>     #- --grpc_max_threads=<int_val>
      ...
```

#### Credentials <div id='serving_creds'>
Not needed for s<model_id>s (model-serving)

### visual-anomaly-nginx <div id='nginx'>

Routes requests that are sent to model_proxy to the right s<model_id>s using 'model-id' grpc metadata, longrunning service.

#### Configuration <div id='nginx_conf'>

This nginx services configuration file is generated here /<deployment_dir>/bundle/nginx.conf.

#### Credentials <div id='nginx_creds'>

Not needed for visual-anomaly-nginx

### [model_proxy](https://bitbucket.org/microblink/mlp-model-proxy/src/master/) <div id='model_proxy'>

This service is the only one that has a port exposed on the host machine, this is where users send requests.
Unpacks request data for tensorflow serving and maps tensorflow serving outputs to user friendly outputs, longrunning service.

#### Configuration <div id='model_proxy_conf'>

This service uses the bundle-signature.yaml that was uploaded to model registry together with the model to determine types for inputs and outputs, this file shouldn't be edited.
To use alternative arguments, other than bundle signature, you need to edit /base/bundle/docker-compose.yaml service section.
The following example shows the green lines that you can uncomment and edit in /base/bundle/docker-compose.yaml to use other args for model proxy:
``` diff
  model_proxy
      ...
    volumes:
      - ./proxy/bundle-signature.yaml:/etc/bundle-signature.yaml
    command:
      - mproxy
      - server
      - --tf-serving-connection-string
      - <tf_serving_endpoint>
>     #- --inference-engine-service-name-format
>     #- <inference_svc_name_format>
      - -c
      - /etc/bundle-signature.yaml
>     #- --target-bundle
>     #- <target_bundle_name>
```

To change the default http and grpc port edit .env in /<deployment_dir>/bundle/conf/.env.
The following example shows the lines you should edit in /<deployment_dir>/bundle/conf/.env to change the ports:
``` diff
...
MODEL_PROXY_HTTP_PORT=8000
MODEL_PROXY_GRPC_PORT=8005
...
```

#### Credentials <div id='model_proxy_creds'>

Not needed for model_proxy

### How to deploy <div id='deploy'>
1. make sure [Prerequisites](#prerequisites) are satisfied on target machine
2. copy the content of docker-compose-gen directory to your target machine
3. copy /example and rename it to whatever you want (/<deployment_dir> in examples)
4. add all needed credentials (see for each service in Services -> <service_name> -> Credentials section)
5. If default configuration is not suited for your needs, edit configuration files (see for each service in Services -> <service_name> -> Configuration)
6. add .env to /<deployment_dir> with the full path to that location (run `pwd` in /<deployment_dir> ) like this:
``` diff
REL_DIR=<pwd_output>
```
7. run `docker compose up -d` from /<deployment_dir>
8. test model proxy with `curl localhost:8000/api/v1/config`