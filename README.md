# BlinkID Verify

This repository holds deployment package deliveries for deploying Microblinks document verification solution.

## Pre-requisites
### Your licence key

To use either helm or docker-compose based deployment you will need a licence key.
You can acquire it on [developer.microblink.com](https://developer.microblink.com/).

## Helm
For production ready, user facing loads we prepare a helm chart that can be used to deploy our solution on your Kubernetes infrastructure. 
Using our helm you can easily configure autoscaling rules and resource requirements for each service, making it easy to install
on existing Kuberentes clusters. For more information please refer to [README.md](helm/doc-ver/README.md) under helm/doc-ver.

## Docker compose
If you are working within a: 
 - constrainted environment
 - do not require horizontal scaling/have predictable loads
 - k8s is simply not an option

You can deploy the same service stack using `docker-compose`. The only depenency you need to
have on the machine you wish to run our document verification solution is to have `docker` installed. For more information and install guideline plese follow the instructions in
[docker-compose/README.md](docker-compose/README.md)


## Product documentation
The documentation for BlinkID Verify API is maintained [here](https://blinkidverify.docs.microblink.com/docs/category/introduction) and API reference is [here](https://blinkidverify.docs.microblink.com/docs/api/request/).

## Release Notes
Releases notes are published [here](https://blinkidverify.docs.microblink.com/docs/docver/release-notes)