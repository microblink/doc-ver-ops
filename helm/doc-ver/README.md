# doc-ver

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.17.1](https://img.shields.io/badge/AppVersion-3.17.1-informational?style=flat-square)

Single-image Document Verification deployment

## Architecture
This chart deploys the single-image container (API + Worker + Models in one pod).

## Usage

### Prerequisites
To install helm and setup your local environment, please follow the instructions [here](docs/environment-setup.md).

### Installing the Chart
This helm chart is published in Microblink's helm chart repository - `https://helm.microblink.com/charts`.

To use it, simply add the repository to your helm client:
```bash
helm repo add microblink https://helm.microblink.com/charts
helm repo update
```

Then you can install the chart using:
```bash
helm install my-release -f <path to values file you want to use to configure the chart> microblink/doc-ver
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.license.applicationId | string | `""` | App identifier from microblink developer hub |
| auth.license.createSecret | bool | `false` | enable if you want to create license secret as part of this charts deployment |
| auth.license.licenseKey | string | `""` | if createSecret is set to true, set the license key here |
| auth.license.secretName | string | `"license-key"` | name of license-key secret |
| singleImage.affinity | object | `{}` | deployment affinity |
| singleImage.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | container security context |
| singleImage.enabled | bool | `true` | enable single-image deployment (API + Worker + Models in one container) |
| singleImage.env.API_TIMEOUT_SECONDS | string | `"30"` | API / queue configuration |
| singleImage.env.HEALTH_PORT_BASE | string | `"18080"` | base port for worker health servers |
| singleImage.env.JobTimeoutMinutes | string | `"2"` |  |
| singleImage.env.MPROXY_MODELS_ENDPOINT | string | `"localhost:8500"` | TF Serving endpoint inside the container |
| singleImage.env.MPROXY_MODELS_ENDPOINT_SSL | string | `"OFF"` |  |
| singleImage.env.WORKER_COUNT | string | `"2"` | worker pool size |
| singleImage.env.WorkerPollTimeoutSeconds | string | `"10"` |  |
| singleImage.extraEnv | list | `[]` | additional env vars (name/value pairs) |
| singleImage.extraSecrets | list | `[]` | list of secret names to be added to deployment environment |
| singleImage.fullnameOverride | string | `""` | if set, overrides deployment, hpa, ingress, and service metadata.name |
| singleImage.image.pullPolicy | string | `"IfNotPresent"` | deployment docker image pull policy |
| singleImage.image.pullSecrets | list | `[]` | deployment docker image pull secrets |
| singleImage.image.repository | string | `"us-docker.pkg.dev/document-verification-public/verify-public/single-image"` | deployment docker image repository |
| singleImage.image.tag | string | `"3.17.1"` | deployment docker image tag, if not set, version will be used as tag |
| singleImage.ingress.annotations | object | `{}` |  |
| singleImage.ingress.className | string | `""` |  |
| singleImage.ingress.enabled | bool | `false` | enable if you want to expose the service |
| singleImage.ingress.hosts[0] | object | `{"host":"docver.microblink.com","paths":["/docver/","/api/"]}` | if you want to expose the service, set the host name |
| singleImage.ingress.pathType | string | `"ImplementationSpecific"` |  |
| singleImage.ingress.tls | list | `[]` |  |
| singleImage.logFiles.enabled | bool | `false` | enable writing log files to /var/log (stdout/stderr is always enabled) |
| singleImage.nameOverride | string | `"doc-ver"` | if set, overrides app.kubernetes.io/name |
| singleImage.nodeSelector | object | `{}` | deployment node selector |
| singleImage.podAnnotations | object | `{}` | deployment podAnnotations |
| singleImage.podSecurityContext | object | `{}` | pod security context |
| singleImage.probes.liveness.failureThreshold | int | `5` |  |
| singleImage.probes.liveness.initialDelaySeconds | int | `60` |  |
| singleImage.probes.liveness.path | string | `"/health/live"` |  |
| singleImage.probes.liveness.periodSeconds | int | `30` |  |
| singleImage.probes.liveness.timeoutSeconds | int | `5` |  |
| singleImage.probes.readiness.failureThreshold | int | `10` |  |
| singleImage.probes.readiness.initialDelaySeconds | int | `30` |  |
| singleImage.probes.readiness.path | string | `"/health/ready"` |  |
| singleImage.probes.readiness.periodSeconds | int | `15` |  |
| singleImage.probes.readiness.timeoutSeconds | int | `5` |  |
| singleImage.probes.startup.enabled | bool | `true` |  |
| singleImage.probes.startup.failureThreshold | int | `60` |  |
| singleImage.probes.startup.path | string | `"/health/ready"` |  |
| singleImage.probes.startup.periodSeconds | int | `10` |  |
| singleImage.probes.startup.timeoutSeconds | int | `5` |  |
| singleImage.replicaCount | int | `1` | number of replicas to run |
| singleImage.resources.limits.cpu | string | `"4"` | deployment resource cpu limit |
| singleImage.resources.limits.memory | string | `"8Gi"` | deployment resource memory limit |
| singleImage.resources.requests.cpu | string | `"2"` | deployment resource cpu requests |
| singleImage.resources.requests.memory | string | `"4Gi"` | deployment resource memory requests |
| singleImage.service.port | int | `8080` | service and container port |
| singleImage.service.type | string | `"ClusterIP"` | service type |
| singleImage.serviceAccount.annotations | object | `{}` | annotations for the service account |
| singleImage.serviceAccount.create | bool | `true` | create a service account |
| singleImage.serviceAccount.name | string | `""` | if set, overrides the name of the service account |
| singleImage.terminationGracePeriodSeconds | int | `30` | graceful shutdown timeout |
| singleImage.tolerations | list | `[]` | deployment tolerations |
| singleImage.topologySpreadConstraints | list | `[]` | deployment topologySpreadConstraints |
| singleImage.volumes.tmp | object | `{"sizeLimit":""}` | size limits for writable emptyDir volumes (optional, e.g. "1Gi") |
| singleImage.volumes.varLog.sizeLimit | string | `""` |  |
| singleImage.volumes.varTmp.sizeLimit | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

## Environment variables

The single-image container accepts a set of configuration env vars. The most commonly tuned ones:

- `WORKER_COUNT` – number of worker processes in the container
- `HEALTH_PORT_BASE` – base port for worker health endpoints
- `API_TIMEOUT_SECONDS`, `WorkerPollTimeoutSeconds`, `JobTimeoutMinutes` – internal API/queue tuning
- `MPROXY_MODELS_ENDPOINT`, `MPROXY_MODELS_ENDPOINT_SSL` – should remain `localhost:8500` / `OFF` for single-image

Additional env vars can be injected via `singleImage.extraEnv`:

```yaml
singleImage:
  extraEnv:
    - name: DocVerV2InflightLimit
      value: "4"
    - name: DocVerV2QueueLimit
      value: "0"
```

## Logging

By default, logs go to stdout/stderr (preferred for container logging).
Optional file logging can be enabled by setting `singleImage.logFiles.enabled=true`, which adds:

- `/var/log/tf-serving.log`
- `/var/log/api.log`
- `/var/log/worker-N.log`

In Kubernetes, stdout/stderr is captured by the kubelet and rotated by the container runtime. The `/var/log` files live on an `emptyDir` volume. If that volume fills up, the container will start failing to write logs and may crash or be evicted under node disk pressure. To mitigate:

- keep log ingestion on stdout/stderr (preferred),
- set `singleImage.volumes.*.sizeLimit` to cap `emptyDir` usage, and
- use centralized log collection instead of retaining large files in-container.

## Migration guide (multi-component → single-image)

It should be fairly straightforward to migrate from the multi-service compose to the single-image deployment since it's designed to be backwards compatible. The only real difference is the number containers that run.

1. Uninstall the old release (API/Runner/Model proxy charts).
2. Create a new license secret containing:
   - `LICENSE_KEY`
   - `LICENSE_APPLICATION_ID`
3. Update your values file to the new `singleImage` structure and image.
4. Deploy the new chart and validate readiness with `/health/ready`.

## Scaling advice

- Avoid changing `WORKER_COUNT`, especially if you're not changing the resource limits. `WORKER_COUNT` is exposed to allow you to rightsize the performance if you have specific requirements for your container resource allocation.
- We recommend scaling horizontally.

## Throughput and latency

On average, a single verification takes 2-3 seconds. This time can vary depending on the document type, settings, and resource constraints.

By default, each image runs 2 worker processes, meaning a single container can handle roughly 0.8 requests per second.

These requests are queued internally (up to a limit), so the container can easily buffer and handle spikes (which will cause additional latency, of course).

When the API is too saturated, it will start rejecting requests with a 429 status code.

## Horizontal scaling

There are three primary horizontal scaling approaches you can use to get higher throughput from the single image.

1. Run a higher flat number of replicas. 

Since the API can buffer requests, consider if you really need dynamic scaling or large numbers of replicas. 

A single instance is capable processing some 70000 requests in a day. If you don't experience large spikes, this might be good enough. However, it's always best to have redundancy, and you likely have concentrated peak loads. Unless these loads are huge, running a few, or up to 10 replicas at all times is likely an excellent, cost effective solution to handle all your traffic.

2. Dynamic scaling based on CPU usage.

The easiest way to scale dynamically is to use HPA with a CPU metric that's a proxy for load. This generally works ok, because the processing is CPU heavy. However, there are multiple workers and a verification is not a uniform process so there's also a lot of variance and noise.

It's better to set somewhat lower thresholds (~50-60%) and have more aggressive scaling. However, if you have a lot of traffic and pods, this might end up being wasteful. In that case, we'd recommend queue based scaling.

3. Queue based scaling

By putting a fast gateway and queue in front of the container (PubSub, RabbitMQ, etc.), and utilizing KEDA and queue metrics, you can scale the number of images based on the number of items in the queue. This is the most efficient way to scale, but it requires additional infrastructure and configuration. It's most likely not cost effective unless you have large loads or extreme spikes.

That might look something like this:

```yaml
minReplicas: 4
maxReplicas: 100
pollingInterval: 1
  triggers:
    Rate-based scaling: keep enough pods for current throughput
    - type: rabbitmq
      metadata:
        protocol: http # Rate based scaling requires HTTP protocol with RMQ
        queueName: document.verification.queue
        mode: MessageRate
        value: "0.33" # ~3 instances per RPS (should be about right with default settings) 
        activationValue: "0.5" # activate policy at 0.5 RPS
```

or something like this for more control over the scaling behavior:

```yaml
horizontalPodAutoscalerConfig:
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
        - type: Pods
          value: 50           # up to +50 pods / 30s
          periodSeconds: 30
        - type: Percent
          value: 100          # or +100% / 30s
          periodSeconds: 30
      selectPolicy: Max       # most aggressive allowed

    scaleDown:
      stabilizationWindowSeconds: 60
      policies:
        - type: Pods
          value: 20           # can drop 20 pods / 30s
          periodSeconds: 30
        - type: Percent
          value: 20           # or 20% / 30s
          periodSeconds: 30
      selectPolicy: Max       # take the more aggressive of the two