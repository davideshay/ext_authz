# ext_authz

A lightweight external authorization server for Envoy Gateway that extracts `AccessToken-*` cookies
set by Keycloak OIDC login flows and injects them as `Authorization: Bearer` headers.

## Features

- Written in Go
- Stateless and fast
- Extracts access tokens from Keycloak cookies
- Designed to be used with Envoy Gateway's `ext_authz` support

## Usage

### Build and Push Docker Image

```bash
docker build -t your-dockerhub-username/ext-authz:latest .
docker push your-dockerhub-username/ext-authz:latest
```

### Deploy to Kubernetes

```bash
kubectl apply -f deploy/k8s/
```

### Envoy Gateway Configuration

Use the `EnvoyExtensionPolicy` to call this service before applying `SecurityPolicy`.

## License

MIT