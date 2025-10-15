# Setting up local environment

To use `helm` to install and manage applications on a Kubernetes cluster there are some prerequisites that need to be met.
This guide will walk you through the steps to set up your local environment to use `helm`.

## Setting up cluster access

To manage applications on a Kubernetes cluster, you need to have access to the cluster.

To do this, you need to have the `kubectl` command-line tool installed and configured to use the cluster.

To install `kubectl` best follow official Kubernetes documentation: [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/).
It offers you several ways to install `kubectl` on your local machine, depending on your OS.

After you have installed `kubectl`, you need to configure it to use the cluster.

Cluster access configurations for `kubectl` are stored in the `~/.kube/config` file.
Depending on your cluster setup there are different tools that help you easily configure `kubectl` to use the cluster.

### Google cloud - GKE

If you are using Google Kubernetes Engine (GKE) you can use the `gcloud` command-line tool to configure `kubectl` to use the cluster.

To install `gcloud` best follow official Google Cloud documentation: [Installing Google Cloud SDK](https://cloud.google.com/sdk/docs/install).

To "login" to your Google Cloud account run:

```bash
gcloud auth login
```

Next, google requires you to have auth plugin to work with Kubernetes Engine clusters. To install it run:

```bash
gcloud components install gke-gcloud-auth-plugin
```

For troubleshooting or more details please refer [here](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#install_plugin).

Once that is configured you can use simple command to authenticate `kubectl` with the cluster:

```bash
gcloud container clusters get-credentials CLUSTER_NAME --zone=ZONE --project=PROJECT
```

Replace `CLUSTER_NAME`, `ZONE` and `PROJECT` with your actual values.

Once that is done you can verify that `kubectl` is configured correctly by running:

```bash
kubectl get nodes
```

You should see a list of nodes in your cluster.

## Installing Helm

To install `helm` on your local machine, besst follow the official Helm documentation: [Installing Helm](https://helm.sh/docs/intro/install/).
