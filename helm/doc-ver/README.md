# doc-ver

![Version: 0.3.8](https://img.shields.io/badge/Version-0.3.8-informational?style=flat-square)

## C4 Model
![Scheme](docs/docver-deployment.svg)

## Usage

This helm chart is published in microblinks helm chart repository - `https://helm.microblink.com/charts`.

To use it, simply add the repository to your helm client:
```bash
helm repo add microblink https://helm.microblink.com/charts
helm repo update
```

Then you can install the chart using:
```bash
helm install my-release -f <path to values file you want to use to configure the chart> mb/doc-ver
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 13.2.27 |
| https://helm.microblink.com/charts | anomdet-intermediary | 0.0.8 |
| https://helm.microblink.com/charts | bundle-visual-anomaly-core-versions | 0.4.6 |
| https://helm.microblink.com/charts | doc-ver-api | 0.0.5 |
| https://helm.microblink.com/charts | embedding-store | 0.3.3 |
| https://helm.microblink.com/charts | mlp-local-storage | 2.1.0 |
| https://helm.microblink.com/charts | visual-anomaly | 0.0.8 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| anomdet-intermediary.anomdetIntermediaryConfig | object | `{"collection-name":"mdv-1458","model-id":"6478fcb410dcce6d3b037199","model-name":"visual-anomaly","parallel-queries":200}` | do not update anomdetIntermediaryConfig values, they are fixed for a specific docver release |
| anomdet-intermediary.autoscaling.enabled | bool | `false` | if enabled, deployment will be autoscaled |
| anomdet-intermediary.autoscaling.maxReplicas | int | `2` | max replicas hpa will scale up to |
| anomdet-intermediary.autoscaling.minReplicas | int | `1` | min replicas hpa will scale down to |
| anomdet-intermediary.autoscaling.targetCPUUtilizationPercentage | int | `80` | if set, hpa will scale based on cpu usage, target cpu usage percentage |
| anomdet-intermediary.autoscaling.targetMemoryUtilizationPercentage | int | `80` | if set, hpa will scale based on memory usage, target memory usage percentage |
| anomdet-intermediary.image.pullSecrets[0].name | string | `"eu.gcr.io"` |  |
| anomdet-intermediary.image.repository | string | `"eu.gcr.io/microblink-identity/anomaly-detection-intermediary/onprem"` |  |
| anomdet-intermediary.ingress.enabled | bool | `false` |  |
| anomdet-intermediary.replicaCount | int | `1` |  |
| anomdet-intermediary.resources.limits.cpu | int | `1` | deployment resource cpu limit |
| anomdet-intermediary.resources.limits.memory | string | `"1Gi"` | deployment resource memory limit |
| anomdet-intermediary.resources.requests.cpu | string | `"300m"` | deployment resource cpu requests |
| anomdet-intermediary.resources.requests.memory | string | `"512Mi"` | deployment resource memory requests |
| auth.dbCreds.createSecret | bool | `true` | if you do not expect multiple database users and db will not be exposed to any external traffic, set this to true and it will create secret with fixed credentials |
| auth.dbCreds.secretName | string | `"mb-docver-db-creds"` | name of the secret, this string value must be updated in both postgresql and embedding-store |
| auth.licence.createSecret | bool | `false` | enable if you want to create licence secret as part of this charts deployment |
| auth.licence.licenseKey | string | `""` | if createSecret is set to true, set the license key here |
| auth.licence.secretName | string | `"license-key"` | name of license-key secret, if changed, it must be updated in doc-ver-api |
| auth.serviceAccount.createBothSecrets | bool | `false` | if you want to create service account secret and image pull secret as part of this charts deployment |
| auth.serviceAccount.imgPullSecretName | string | `"eu.gcr.io"` | the name of pull secret that will be used to pull images from the registry, if updated, it must be updated in values for all services |
| auth.serviceAccount.secretName | string | `"sa-json"` | name of the secret, this string value must be updated in both doc-ver-api and embedding-store |
| auth.serviceAccount.serviceAccountJsonB64 | string | `""` | base64 value of service account json you got from developer.microblink.com |
| bundle-visual-anomaly-core-versions.bundle.models.autoscaling.maxReplicas | int | `3` |  |
| bundle-visual-anomaly-core-versions.bundle.models.autoscaling.minReplicas | int | `1` |  |
| bundle-visual-anomaly-core-versions.bundle.models.autoscaling.type | string | `"hpa"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.globalStorage.bucket | string | `"identity-enc-models-prod"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.globalStorage.secret | string | `"sa-json"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.globalStorage.type | string | `"gs"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.storage.bucket | string | `"identity-enc-models-prod"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.storage.secret | string | `"sa-json"` |  |
| bundle-visual-anomaly-core-versions.bundle.models.model.storage.type | string | `"gs"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.autoscaling.enabled | bool | `true` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.autoscaling.maxReplicas | int | `3` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.autoscaling.minReplicas | int | `1` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.autoscaling.targetCPUUtilizationPercentage | string | `"80"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.env.GOGC | string | `"50"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.image.repository | string | `"eu.gcr.io/microblink-identity/mlp-model-proxy/onprem"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.image.tag | string | `"v0.17.7"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.ingress.enabled | bool | `false` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.maxLimits.cpu | int | `2` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.maxLimits.memory | string | `"2Gi"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.minLimits.cpu | string | `"500m"` |  |
| bundle-visual-anomaly-core-versions.bundle.proxy.minLimits.memory | string | `"1Gi"` |  |
| bundle-visual-anomaly-core-versions.bundle.serving.nginx.resolver | string | `"kube-dns.kube-system.svc.cluster.local"` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.engine.type | string | `"triton"` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.image.repository | string | `"eu.gcr.io/microblink-identity/tritonserver-cpu-onnxruntime/onprem"` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.image.tag | string | `"23.06"` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.maxLimits.cpu | int | `2` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.maxLimits.memory | string | `"2Gi"` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.minLimits.cpu | int | `2` |  |
| bundle-visual-anomaly-core-versions.models.6478fcb410dcce6d3b037199.minLimits.memory | string | `"2Gi"` |  |
| doc-ver-api.autoscaling | object | `{"cpu":{"enabled":true,"target":80},"enabled":false,"maxReplicas":3,"memory":{"enabled":false,"target":80},"minReplicas":1}` | Autoscaling configurations |
| doc-ver-api.autoscaling.cpu.enabled | bool | `true` | if enabled, hpa will scale based on cpu usage |
| doc-ver-api.autoscaling.cpu.target | int | `80` | target cpu usage percentage |
| doc-ver-api.autoscaling.enabled | bool | `false` | if enabled, deployment will be autoscaled |
| doc-ver-api.autoscaling.maxReplicas | int | `3` | max replicas hpa will scale up to |
| doc-ver-api.autoscaling.memory.enabled | bool | `false` | if enabled, hpa will scale based on memory usage |
| doc-ver-api.autoscaling.memory.target | int | `80` | target memory usage percentage |
| doc-ver-api.autoscaling.minReplicas | int | `1` | min replicas hpa will scale down to |
| doc-ver-api.env.LICENSEE | string | `"localhost"` | don't change unless communicated by Microblink support team |
| doc-ver-api.extraSecrets | list | `["license-key"]` | unclear on the content of the secret, check out the tempates/license-key.yaml |
| doc-ver-api.image.pullSecrets[0].name | string | `"eu.gcr.io"` |  |
| doc-ver-api.image.repository | string | `"eu.gcr.io/microblink-identity/web-api-doc-ver"` |  |
| doc-ver-api.image.tag | string | `"2.4.0"` |  |
| doc-ver-api.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/client-max-body-size" | string | `"15m"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-origin" | string | `"*"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect" | string | `"true"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/proxy-body-size" | string | `"100m"` |  |
| doc-ver-api.ingress.annotations."nginx.ingress.kubernetes.io/ssl-redirect" | string | `"true"` |  |
| doc-ver-api.ingress.enabled | bool | `false` | enable if you want to expose the service |
| doc-ver-api.ingress.hosts[0] | object | `{"host":"docver.microblink.com","paths":["/docver","/info","/barcode"]}` | if you want to expose the service, set the host name |
| doc-ver-api.ingress.pathType | string | `"ImplementationSpecific"` |  |
| doc-ver-api.replicaCount | int | `1` | using fixed number of replicas if autoscaling is not enabled |
| doc-ver-api.resources.limits.cpu | int | `2` |  |
| doc-ver-api.resources.limits.memory | string | `"2Gi"` |  |
| doc-ver-api.resources.requests.cpu | int | `1` |  |
| doc-ver-api.resources.requests.memory | string | `"1Gi"` |  |
| embedding-store.seeder.config.collectionCreateWorkers | int | `200` |  |
| embedding-store.seeder.config.collectionInsertBatch | int | `1` |  |
| embedding-store.seeder.config.collectionInsertWorkers | int | `50` |  |
| embedding-store.seeder.enabled | bool | `false` |  |
| embedding-store.seeder.grpc.grpcRecvSize | string | `"52428800"` |  |
| embedding-store.seeder.grpc.grpcSendSize | string | `"52428800"` |  |
| embedding-store.seeder.image.pullSecrets[0].name | string | `"eu.gcr.io"` |  |
| embedding-store.seeder.image.repository | string | `"eu.gcr.io/microblink-identity/embedding-store/onprem"` |  |
| embedding-store.seeder.resources.limits.cpu | int | `1` |  |
| embedding-store.seeder.resources.limits.memory | string | `"2Gi"` |  |
| embedding-store.seeder.resources.requests.cpu | string | `"500m"` |  |
| embedding-store.seeder.resources.requests.memory | string | `"1Gi"` |  |
| embedding-store.seeder.secret | string | `"sa-json"` |  |
| embedding-store.seeder.seedStore.gc.bucket | string | `"docver-va-releases"` |  |
| embedding-store.seeder.seedStore.gc.enabled | bool | `true` |  |
| embedding-store.seeder.seedStore.gc.prefix | string | `"full-db/6478fcb410dcce6d3b037199"` |  |
| embedding-store.seeder.seedStore.s3.enabled | bool | `false` |  |
| embedding-store.server.autoscaling.enabled | bool | `false` | if enabled, server deployment will be autoscaled |
| embedding-store.server.autoscaling.maxReplicas | int | `2` | max replicas hpa will scale up to |
| embedding-store.server.autoscaling.minReplicas | int | `1` | min replicas hpa will scale down to |
| embedding-store.server.autoscaling.targetCPUUtilizationPercentage | int | `80` | if set, hpa will scale based on cpu usage, target memory usage percentage |
| embedding-store.server.autoscaling.targetMemoryUtilizationPercentage | int | `80` | if set, hpa will scale based on memory usage, target memory usage percentage |
| embedding-store.server.database.pgvector.addr | string | `"postgresql:5432"` |  |
| embedding-store.server.database.pgvector.addrPrepandReleaseName | bool | `false` | set this to true you are using postgresql.emabled: true - postgres as a part of this helm release |
| embedding-store.server.database.pgvector.connectionStringParams | string | `"pool_max_conns=60&pool_max_conn_idle_time=30s&pool_max_conn_lifetime=60s"` |  |
| embedding-store.server.database.pgvector.enabled | bool | `true` |  |
| embedding-store.server.grpc.grpcRecvSize | string | `"52428800"` |  |
| embedding-store.server.grpc.grpcSendSize | string | `"52428800"` |  |
| embedding-store.server.image.pullSecrets[0].name | string | `"eu.gcr.io"` |  |
| embedding-store.server.image.repository | string | `"eu.gcr.io/microblink-identity/embedding-store/onprem"` |  |
| embedding-store.server.resources.limits.cpu | int | `2` |  |
| embedding-store.server.resources.limits.memory | string | `"2Gi"` |  |
| embedding-store.server.resources.requests.cpu | string | `"500m"` |  |
| embedding-store.server.resources.requests.memory | string | `"1Gi"` |  |
| embedding-store.server.secret | string | `"mb-docver-db-creds"` |  |
| mlp-local-storage.PersistentVolume[0].capacity | string | `"1300Gi"` |  |
| mlp-local-storage.PersistentVolume[0].nodes[0] | string | `"s1"` |  |
| mlp-local-storage.PersistentVolume[0].storageClass.name | string | `"efs-sc"` |  |
| mlp-local-storage.PersistentVolume[0].storageClass.reclaimPolicy | string | `"Delete"` |  |
| mlp-local-storage.PersistentVolume[0].storageType | string | `"ssd"` |  |
| mlp-local-storage.PersistentVolume[0].volumenameprefix | string | `"test-tmp-delete-when-seen-"` |  |
| mlp-local-storage.StorageClass[0].create | bool | `true` |  |
| mlp-local-storage.StorageClass[0].name | string | `"efs-sc"` |  |
| mlp-local-storage.StorageClass[0].provisioner | string | `"kubernetes.io/no-provisioner"` |  |
| mlp-local-storage.enabled | bool | `false` | enable this ONLY if you do not have dynamic storage provisioning in k8s cluster, likely using on-prem, baremetal k8s |
| postgresql.auth.username | string | `"embedding-store-sa"` | must be fixed to this value, do not change |
| postgresql.enabled | bool | `false` | Disabled, as we expect that the database will be hosted outside of this helm release, e.g in AWS RDS or GCP CloudSQL |
| postgresql.global.postgresql.auth.existingSecret | string | `"mb-docver-db-creds"` |  |
| postgresql.global.postgresql.auth.postgresqlDatabase | string | `"postgres"` |  |
| postgresql.image.pullPolicy | string | `"IfNotPresent"` |  |
| postgresql.image.registry | string | `"docker.io"` |  |
| postgresql.image.repository | string | `"ankane/pgvector"` |  |
| postgresql.image.tag | string | `"v0.5.1"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchLabels."app.kubernetes.io/component" | string | `"primary"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchLabels."app.kubernetes.io/instance" | string | `"argo-wf"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchLabels."app.kubernetes.io/name" | string | `"postgresql"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.namespaces[0] | string | `"placeholder"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| postgresql.primary.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `1` |  |
| postgresql.primary.args[0] | string | `"-c"` |  |
| postgresql.primary.args[1] | string | `"config_file=/bitnami/postgresql/conf/postgresql.conf"` |  |
| postgresql.primary.configuration | string | `"max_connections = 1000\nshared_buffers = 18GB\neffective_cache_size = 24GB\nmaintenance_work_mem = 1GB\ncheckpoint_completion_target = 0.9\nwal_buffers = 16MB\ndefault_statistics_target = 1000\nrandom_page_cost = 1.1\neffective_io_concurrency = 300\nwork_mem = 20MB\nhuge_pages = off\nmin_wal_size = 2GB\nmax_wal_size = 4GB\nmax_worker_processes = 20\nmax_parallel_workers_per_gather = 8\nmax_parallel_workers = 20\nmax_parallel_maintenance_workers = 4\n\nwal_level = minimal\nmax_wal_senders = 0\n\nlisten_addresses = '*'\n"` |  |
| postgresql.primary.containerSecurityContext.enabled | bool | `false` |  |
| postgresql.primary.livenessProbe.failureThreshold | int | `600` |  |
| postgresql.primary.persistence.enabled | bool | `true` |  |
| postgresql.primary.persistence.size | string | `"1300Gi"` |  |
| postgresql.primary.persistence.storageClass | string | `"efs-sc"` |  |
| postgresql.primary.podSecurityContext.enabled | bool | `false` |  |
| postgresql.primary.resources.limits.cpu | int | `20` |  |
| postgresql.primary.resources.limits.memory | string | `"24Gi"` |  |
| postgresql.primary.resources.requests.cpu | int | `10` |  |
| postgresql.primary.resources.requests.memory | string | `"12Gi"` |  |
| postgresql.primary.service.type | string | `"ClusterIP"` |  |
| postgresql.primary.tolerations[0].effect | string | `"NoSchedule"` |  |
| postgresql.primary.tolerations[0].key | string | `"kubernetes.io/workload"` |  |
| postgresql.primary.tolerations[0].operator | string | `"Equal"` |  |
| postgresql.primary.tolerations[0].value | string | `"storage"` |  |
| visual-anomaly.autoscaling.cpu.enabled | bool | `true` | if enabled, hpa will scale based on cpu usage |
| visual-anomaly.autoscaling.cpu.target | int | `80` | target cpu usage percentage |
| visual-anomaly.autoscaling.enabled | bool | `false` | if enabled, deployment will be autoscaled |
| visual-anomaly.autoscaling.maxReplicas | int | `1` | max replicas hpa will scale up to |
| visual-anomaly.autoscaling.memory.enabled | bool | `false` | if enabled, hpa will scale based on memory usage |
| visual-anomaly.autoscaling.memory.target | int | `80` | target memory usage percentage |
| visual-anomaly.autoscaling.minReplicas | int | `1` | min replicas hpa will scale down to |
| visual-anomaly.enabled | bool | `true` |  |
| visual-anomaly.image.pullSecrets[0].name | string | `"eu.gcr.io"` |  |
| visual-anomaly.ingress.enabled | bool | `false` |  |
| visual-anomaly.replicaCount | int | `1` | using fixed number of replicas if autoscaling is not enabled |
| visual-anomaly.resources.limits.cpu | int | `1` |  |
| visual-anomaly.resources.limits.memory | string | `"1Gi"` |  |
| visual-anomaly.resources.requests.cpu | string | `"300m"` |  |
| visual-anomaly.resources.requests.memory | string | `"0.5Gi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)