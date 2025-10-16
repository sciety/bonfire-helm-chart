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

Then you deploy the chart using (replacing your database values):

```
helm upgrade --install \
  bonfire-instance bonfire/bonfire \
  --set postgres.host="postgres-database.hostname" \
  --set postgres.db="postgres" \
  --set postgres.user="postgres" \
  --set postgres.password="postgres"
```

By default this will depoy with generated secrets for `SECRET_KEY_BASE`, `SIGNING_SALT` and `ENCRYPTION_SALT`.

## Important values

Most documented values are available in the README.md file in the [./charts/bonfire](./charts/bonfire) directory.

You can use your own values for by creating an existing secret in the same namespace on your cluster, then setting the value `secrets.existingAppSecret` to the name of the scret when you deploy.

Beyond the `postgres.*` and `ingress.*`, you can inject config for other dependent services via `extraEnv.*` `and extraEnvFrom.*` using the bonfire documented ENV vars, for example:

```
# First create a secret in the cluster
kubectl create secret generic env-vars-with-secrets \
  --from-literal=MAIL_KEY=supersecret \
  --from-literal=MEILI_MASTER_KEY=supersecret \
  --from-literal=ORCID_CLIENT_ID=supersecret \
  --from-literal=ORCID_CLIENT_SECRET=supersecret \
  --from-literal=ZENODO_CLIENT_ID=supersecret \
  --from-literal=ZENODO_CLIENT_SECRET=supersecret \
  --from-literal=ZENODO_ENV=supersecret

# Set bonfire env var via extraEnv
# Inject secret env vars using the secret above and extraEnvFrom
helm upgrade --install \
  bonfire-instance bonfire/bonfire \
  --set postgres.host="postgres-database.hostname" \
  --set postgres.db="postgres" \
  --set postgres.user="postgres" \
  --set postgres.password="postgres" \
  \
  --set extraEnv.UPLOADS_S3_BUCKET="my-s3-bucket" \
  --set extraEnv.UPLOADS_S3_REGION="us-east-1" \
  --set extraEnv.MAIL_BACKEND="sendgrid" \
  --set extraEnv.SEARCH_ADAPTER="meili" \
  --set extraEnv.SEARCH_MEILI_INSTANCE="meili.hostname" \
  \
  --set extraEnvFrom[0].secretRef.name="env-vars-with-secrets"
```
