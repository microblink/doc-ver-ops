# Docver docker-compose deployment (single-image)

This deployment runs the **single-image** container (API + Worker + Models in one container).

## Prerequisites
- docker >= 20.10.5
- docker compose >= 2.22.0

## Quickstart

Clone this repository and position yourself in the root:
```bash
git clone git@github.com:microblink/doc-ver-ops.git && cd doc-ver-ops
```

Initialize your deployment:
```bash
cd docker-compose
bash init.sh <deployment_name> <licence_key> <application_id>
```

This creates a new directory in `docker-compose/<deployment_name>` containing config and `docker-compose.yaml`.

Start the deployment:
```bash
cd <deployment_name>
docker-compose up -d
```

## Inspecting logs
```bash
docker-compose logs doc-ver-single
```

## Endpoint
The Document verification API is available on port `8080` by default.
To change it, update `DOC_VER_API_PORT` in `conf/doc-ver-single-image/.env`.

## Resource requirements
Resource limits are configured in `conf/doc-ver-single-image/.env`.

## Logging
Logs are emitted to stdout/stderr (view via `docker-compose logs doc-ver-single`) and also written to files under `/var/log` inside the container:

- `/var/log/tf-serving.log`
- `/var/log/api.log`
- `/var/log/worker-N.log`

File logging is optional. Set `LOG_FILES_ENABLED=1` to enable files; otherwise logs are stdout only.
If the container filesystem fills up due to log growth, writes will fail and the process may crash. Prefer external log collection and keep log files small.

## Environment variables
Core knobs in `conf/doc-ver-single-image/.env`:
- `DOCVER_IMAGE`, `DOCVER_IMAGE_TAG` – image repository and tag
- `WORKER_COUNT` – number of worker processes inside the container
- `HEALTH_PORT_BASE` – base port for worker health endpoints
- `API_TIMEOUT_SECONDS`, `WORKER_POLL_TIMEOUT_SECONDS`, `JOB_TIMEOUT_MINUTES` – internal API/queue tuning
- `LIMITS_*` / `RESERVATIONS_*` – CPU and memory settings

License settings are injected by `init.sh`:
- `LICENSE_KEY`
- `APPLICATION_ID`

## Scaling advice
For predictable workloads, prefer increasing `WORKER_COUNT` before scaling out replicas.
Each replica loads the full model set, so horizontal scaling multiplies memory and storage usage.

## Migration guide (from multi-service compose)

It should be fairly straightforward to migrate from the multi-service compose to the single-image deployment since it's designed to be backwards compatible. The only real difference is the number containers that run.

1. Stop and remove the old stack: `docker-compose down`.
2. Remove old configs under `conf/doc-ver-api`, `conf/doc-ver-runner`, `conf/bundle-doc-ver`.
3. Re-run `init.sh` to generate the single-image config set.
4. Start the new stack with `docker-compose up -d`.

