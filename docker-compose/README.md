# Docver docker-compose deployment

Docver consists of six components, each of which is defined in `base/<component_dir>`.
Both `base` and `template` directories should not be edited and you are expected to configure
your deployment in a separate directory.
To configure this we provide `init.sh` to easily create one or multiple deployment instances and configurations

For more information on the topology of the services that make the solution please refer to
documentation in helm package provided [here](../helm/doc-ver/README.md).

## Prerequisites
* docker compose >= 2.22.0
* docker >= 20.10.5

### Docker compose

To install docker compose, follow the instructions [here](https://docs.docker.com/compose/install/).

If you don't want to "pollute" your docker environment we recommend using a [standalone installation](https://docs.docker.com/compose/install/standalone/) of docker-compose. It is a single binary that you can put in your PATH 
and use it as a regular command as explained in the provided link.

### Your licence key

As mentioned [here](../README.md). You can acquire these on [developer.microblink.com](https://developer.microblink.com/).
If you are using Document verification self-hosted you will need to acquire the licence key from the licences section (under Document verification self-hosted).

# Quickstart - Deploying your instance

Clone this repository and position yourself in the root of the repo:
`git clone git@github.com:microblink/doc-ver-ops.git && cd doc-ver-ops`

## Initialise your environment and running the deployment

To initialize your environment you should use `init.sh` provided in the `docker-compose` directory.

You can do that by running the following commands

```bash
cd docker-compose
bash init.sh <deployment_name> <licence_key> <application_id>
```
Update the values in <> with your own values.
 * `<deployment_name>` - the name of your deployment, we recommend simply using your company name
 * `<licence_key>` - the licence key that you will use to authenticate. This key is acquired on developer.microblink.com under licences - document verification self-hosted.
 * `<application_id>` - application identifier. This value is acquired on developer.microblink.com under licences - document verification 

This will create a new directory in the `docker-compose` directory with the `<deployment_name>` you provided. 
This directory will contain the configuration files for your deployment runnable by a single command `docker-compose up -d`.

To prevent any confusion, if for example I'm working for company `microblink`, my licence key is `someExampleString` and application id is `myapp` I would run the following command:

```bash
bash init.sh microblink someExampleString myapp
```

Afterwards, I would continue to deploy my instance by running the following:

```bash
cd microblink
docker-compose up -d
```

## Inspecting the logs

To inspect the logs of a specific service, run `docker-compose logs <service_name>`.

Available services
* doc-ver-api
* doc-ver-runner


## Where is the Document verification endpoint available?

Once initialized, the Document verification endpoint will be available on the machine 
you started this docker-compose deployment on, on port `8080`.

If you wish to change the port, you can do so by updating the configuration of the `doc-ver-api` service in the
in the `config/doc-ver-api/.env` file, by updating the value of `DOC_VER_API_PORT` variable.


# Resource requirements

For each service you will be able to configure how much CPU and RAM it can use. Alongside `docker-compose.yaml` 
there is a `conf` directory. Inside the `conf` directory there is a directory for each service. Inside each 
service directory there is a `.env` file where you can configure the resource requirements for the service.

We set the default values for each service in the `conf` directory. Please reach out to us if you need to change
the default values as we need to make sure that the services are not starved of resources. Given your expected load
we can help you determine the right values for your deployment.


# Configuration details

We do not expect the need to change the default configuration for each service. However, if you need to change the
parts of our deployment that are not exposed via env vars (that you can configure in `.env` files) you can do so by [extending](https://docs.docker.com/compose/multiple-compose-files/extends/) them in /<your instance>/docker-compose.yaml.
Since creds and conf are loaded outside the /base directory, /<your instance>/.env file needs to be added. Inside there should be an env variable with the full path to the /<your instance> directory on the target server. 

Server prerequisites and configuration options for each component will be described in the following sections.


## Prerequisites
* doc-ver-api licence key

## Components

### [doc-ver-api](https://bitbucket.org/microblink/docver-api/src/)
doc-ver-api docker-compose.yaml will start one longrunning doc-ver-api server service
#### conf
To configure doc-ver-api, an .env file should be added to /<deployment_dir>/conf/doc-ver-api, with the following values:
```
ALLOWED_ORIGINS=<string_value>
LIMITS_CPUS=<int_value>
LIMITS_MEM=<string_value>
RESERVATIONS_CPUS=<int_value>
RESERVATIONS_MEM=<string_value>
```
##### creds
Not needed for doc-ver-api

### [doc-ver-runner](https://bitbucket.org/microblink/docver-api/src/)
doc-ver-runner docker-compose.yaml will start longrunning doc-ver-runner server service. By default one process will be started, you can increase number by setting `REPLICAS` parameter.
#### conf
To configure doc-ver-runner, an .env file should be added to /<deployment_dir>/conf/doc-ver-runner, with the following values:
```
APPLICATION_ID=<string_value>
LIMITS_CPUS=<int_value>
LIMITS_MEM=<string_value>
RESERVATIONS_CPUS=<int_value>
RESERVATIONS_MEM=<string_value>
REPLICAS=<int_value>
```
#### creds
To be able to work, doc-ver-runner needs a license key that you can provide in /<deployment_dir>/creds/doc-ver-runner:
```
LICENSE_KEY=<string_value>
```

### bundle
To configure bundle services, see [base/bundle/README.md](base/bundle/README.md) (Services section)
