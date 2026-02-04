# BlinkID Verify

This repository holds deployment package deliveries for deploying Microblinks document verification solution.

It's packaged a single image that runs a few internal processes responsible for document verification. It's optimized for running in a container with 4 CPUs and 4 GB of RAM.

These values (along with WORKER_COUNT) can be slightly tuned to fit your needs better, but we recommend horizontal scaling for actually increasing throughput (spawning more of these relatively cheap containers), because it has much better ROI.

More on this in the [scaling advice](helm/doc-ver/README.md#scaling-advice) section.

## Pre-requisites
### Your licence key

To use either helm or docker-compose based deployment you will need a licence key.
You can acquire it on [developer.microblink.com](https://developer.microblink.com/).

## Helm
For production-ready, user facing loads we provide a Helm chart that deploys the **single-image** container (API + Worker + Models in one pod).
For more information please refer to [README.md](helm/doc-ver/README.md) under `helm/doc-ver`.

## Docker compose
If you are working within a constrained environment or Kubernetes is not an option, you can deploy the **single-image** container using `docker-compose` (or just run it directly based on the compose file).
For more information and install guidelines please follow the instructions in [docker-compose/README.md](docker-compose/README.md).

## Migration
If you previously used the multi-component stack, follow the migration guide in [the Helm](helm/doc-ver/README.md#migration-guide-multi-component-→-single-image) or [docker-compose](docker-compose/README.md#migration-guide-from-multi-service-compose) README to switch to single-image.


## Product documentation
The documentation for BlinkID Verify API is maintained [here](https://blinkidverify.docs.microblink.com) and API reference is [here](https://blinkidverify.docs.microblink.com/docs/docver/api-reference/api-reference-v2).

## Release Notes
Releases notes are published [here](https://blinkidverify.docs.microblink.com/docs/docver/release-notes/release-notes)
