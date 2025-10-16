# Bonfire Helm Chart

This is a helm chart for deploying Bonfire on a kubernetes cluster.

## Prerequisites

- A Kubernetes cluster set up
- A Postgres database instance, and the hostname and credentials to connect to
- A supported mail service, and the connection details
- (optional) A Meilisearch instance, and the hostname and credentials to connect to
- (optional) An S3-compatible store, and the connection details

## Install the chart with `helm` cli

You need to add the helm repo:

```
helm repo add bonfire https://sciety.github.io/bonfire-helm-chart/
helm repo update
```

Then you deploy the chart using:

```
helm upgrade --install bonfire-instance bonfire/bonfire
```
