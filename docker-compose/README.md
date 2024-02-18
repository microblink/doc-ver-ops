# Docver docker-compose deployment

Docver consists of 5 components, each of which is defined in base/<component_dir>. 
The default setup is defined in /base, and it is not expected to change no matter where the whole docver stack needs to be deployed -> in other words, base should not be edited.
The setup for a real deployment is shown in /template. All the services defined in /base are [included](https://docs.docker.com/compose/multiple-compose-files/include/) in /template/docker-compose.yaml -> to start the whole stack in a single network, `docker compose -f /tempalte/docker-compose.yaml up -d` is enough.

## Prerequisites
* docker compose >= 2.22.0
* docker >= 20.10.5

# Quickstart - Deploying your instance

To get a working deployment of docver do the following.

1. Position yourself in `docker-compose` directory that has `base` and `template` directories.
2. Copy the `template` directory to a new directory, e.g. `<my company name>`.
3. Position yourself in the new directory, e.g. `<my company name>`.
4. Run `bash init.sh <path to serviceacount.json> <contents of your LICENSE KEY>

Summarized in a bash commands:

First initialize the repo and cd into the repo root:
`git clone git@github.com:microblink/doc-ver-ops.git && cd doc-ver-ops`

Then:
```bash
# Position yourself in the root of cloned repository
cd docker-compose
# Copy the template directory to a new directory
cp -r template <my company name>
# Position yourself in the new directory
cd <my company name>
# Run the init script
bash init.sh <path to serviceacount.json> <contents of your LICENSE KEY>

# Finally run the compose
docker-compose up -d
```

## Inspecting logs

To inspect the logs of a specific service, run `docker-compose logs <service_name>`.

Available services
* doc-ver-api
* visual-anomaly
* retrieval-intermediary
* embedding-store-server
* seeder
* pgvector

# Resource requirements

For each service you will be able to configure how much CPU and RAM it can use. Alongside `docker-compose.yaml` 
there is a `conf` directory. Inside the `conf` directory there is a directory for each service. Inside each 
service directory there is a `.env` file where you can configure the resource requirements for the service.

We set the default values for each service in the `conf` directory. Please reach out to us if you need to change
the default values as we need to make sure that the services are not starved of resources. Given your expected load
we can help you determine the right values for your deployment.


## Configuration details
If the exposed env vars are not enough and you still want to override /base services, you can do so by [extending](https://docs.docker.com/compose/multiple-compose-files/extends/) them in /<your instance>/docker-compose.yaml.
Since creds and conf are loaded outside the /base directory, /<your instance>/.env file needs to be added. Inside there should be an env variable with the full path to the /<your instance> directory on the target server. 

Server prerequisites and configuration options for each component will be described in the following sections.


## Prerequisites
* docker engine >= 20.10.5
* docker compose >= 2.22.0
* docker registry credentials (permission to pull from eu.gcr.io/microblink-identity)
* gcloud service account for a bucket where encrypted models will be stored
* doc-ver-api licence key
* embedding store seeder credentials
    * for gcloud: gcloud service account for the bucket where seed data is stored
    * for s3: s3 bucket access key and secret key

## Components

### [doc-ver-api](https://bitbucket.org/microblink/web-api-doc-ver/src/master/)
doc-ver-api docker-compose.yaml will start one longrunning doc-ver-api server service
#### conf
To configure doc-ver-api, an .env file should be added to /<deployment_dir>/conf/doc-ver-api, with the following values:
```
ALLOWED_ORIGINS=<string_value>
ALLOW_CORS=<bool_value>
AVAILABLE_WORKER_TIMEOUT_MS=<int_value>
IMAGE_MAX_SIZE_KB=<int_value>
LICENSEE=<string_value>
WORKER_TIMEOUT_MS=<int_value>
LIMITS_CPUS=<int_value>
LIMITS_MEM=<string_value>
RESERVATIONS_CPUS=<int_value>
RESERVATIONS_MEM=<string_value>
```
#### creds
To be able to work, doc-ver-api needs a license key that you can provide in /<deployment_dir>/creds/doc-ver-api:
```
LICENSE_KEY=<string_value>
```

### [visual-anomaly](https://bitbucket.org/microblink/web-api-visual-anomaly/src/master/)
visual-anomaly docker-compose.yaml will start one longrunning visual-anomaly server service
#### conf
To configure visual-anomaly, an .env file should be added to /<deployment_dir>/conf/visual-anomaly, with the following values:
```
ALLOW_CORS=false
LIMITS_CPUS=2
LIMITS_MEM=2Gb
RESERVATIONS_CPUS=1
RESERVATIONS_MEM=1Gb
```
#### creds
Not needed for visual-anomaly

### [retrieval-intermediary](https://bitbucket.org/microblink/retrieval-intermediary/src/master/)
retrieval-intermediary docker-compose.yaml will start one longrunning retrieval-intermediary server service
#### conf
To configure retrieval-intermediary, an .env file should be added to /<deployment_dir>/conf/retrieval-intermediary, with the following values:
```
COLLECTION_NAME=mdv
PARALLEL_QUERIES=100
```
#### creds
Not needed for retrieval-intermediary

### [embedding-store](https://bitbucket.org/microblink/embedding-store/src/master/)
embedding-store docker-compose.yaml will start three services, pgvector database, seeder and embedding-store-server. 
seeder inserts predefined data to server database and exits when done.
embedding-store-server and pgvector are longrunning services.
#### seeder
##### conf
To configure seeder for s3, seeder.yaml should be added to /<deployment_dir>/conf/embedding-store, with the following values:
```
grpc-recv-size: <int_val>
grpc-send-size: <int_val>

col-create-workers: <int_val>
col-insert-workers: <int_val>
col-insert-batch: <int_val>

s3-seed-store: <bool_val>
s3-seed-store-endpoint: <string_val>
s3-seed-store-secure: <bool_val>
s3-seed-store-bucket: <string_val>
s3-seed-store-prefix: <string_val>
```

To configure seeder for gcs, seeder.yaml shold be added to /<deployment_dir>/conf/embedding-store, with the following values:
```
grpc-recv-size: <int_val>
grpc-send-size: <int_val>

col-create-workers: <int_val>
col-insert-workers: <int_val>
col-insert-batch: <int_val>

gc-seed-store: <bool_val>
gc-seed-store-bucket: <string_val>
gc-seed-store-prefix: <string_val>
```
##### creds
To enable seeder for s3, .env should be added to /<deployment_dir>/creds/embedding-store with the s3 access and secret keys:
```
EMBEDDING_STORE_S3_SEED_STORE_ACCESSKEY=<string_val>
EMBEDDING_STORE_S3_SEED_STORE_SECRETKEY=<string_val>
```
If you get an error mentioning mounting gcs service account even though you configured s3 seeder, try adding an empty gcs.json to /<deployment_dir>/creds/embedding-store 

To enable seeder for gcs, gcs.json [service account](https://cloud.google.com/iam/docs/service-accounts-create#gcloud) file should be added to /<deployment_dir>/creds/embedding-store, looks something like this:
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
#### server
##### conf
To configure server and db, .env file should be added to /<deployment_dir>/creds/embedding-store, with following values:
```
GRPC_RECV_SIZE=<int_value>
GRPC_SEND_SIZE=<int_value>
GRPC_TIMEOUT=<string_value>

PG_VECTOR_CMX_CONN=<int_value>
PG_VECTOR_LIMITS_MEM=<string_value>
PG_VECTOR_RESERVATIONS_MEM=<string_value>
```
##### creds
Not needed for embedding-store server

### bundle
To configure bundle services, see [base/bundle/README.md](base/bundle/README.md) (Services section)
