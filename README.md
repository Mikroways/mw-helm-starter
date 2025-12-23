The main goal to this repository is to have a library of helm scaffoldings to use
with the `helm create` command in order to:

- Automatize chart creation with some of the
  [helm best practices](https://helm.sh/docs/chart_best_practices/) and 
  [helm tips and tricks](https://helm.sh/docs/howto/charts_tips_and_tricks/)
- Act as a baseline to chart development flow.

## How to use it

### Using helm starter plugin

Ensure you have [helm starter plugin](https://github.com/salesforce/helm-starter/tree/master).
Then, run:

```sh
helm starter fetch https://github.com/Mikroways/mw-helm-starter.git
```
> You can update starter using: `helm starter update mw-helm-starter`.

Then simply run:

```sh
helm create testing-starter -p mw-helm-starter/single-image
```

Also you can update your starter using:

```
helm starter update mw-helm-starter
```

### Install using git only

Clone this repository where you want, and pass along the scaffold path to the
`helm create` command:

```sh
# Clone the repo
git clone  https://github.com/Mikroways/mw-helm-starter.git /tmp/mw-helm-starter
# Create the chart for a single image case
helm create testing-starter -p /tmp/mw-helm-starter/single-image
```

## Provided starters

### Single container

[`single-containet`](./single-container) creates a chartm, similar to the one
created by `helm create`, but adds some convenient configuration for
managing container environment variables and persistence:

* `env`: define environment variables using a dictionary.
* `config.env`: defines environment variables to be set using a configmap
* `config.secretEnv`: defines environment variables using a secret. This
  separation from `config.env` allows an independent management of secrets using
  tools like helm secret.
* `persistence`: add support for creating and mounting volumes.

### Multiple containers
[`multiple-containers`](./multiple-containers) extends `single-container` with multiple containers that can define same configuration but under a container name key. For example:

```yaml
containers:
  app:
    image:
      repository: nginx
      pullPolicy: IfNotPresent
      tag: ""

    resources:
      limits:
        cpu: 100m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi

    env: 
      NAME: John
      LAST_NAME: Doe

    config:
      env:
        MY_AWESOME_ENV_VAR: "my awesome var"
      secretEnv:
        MY_SECRET_ENV_VAR: "supersecret"

    ports:
      - name: http
        containerPot: 8080
        protcolo: TCP
    
    persistence:
      enabled: true
      accessModes:
        - ReadWriteOnce
      resources:
      mountName: data
      mountPath: "/data"

    livenessProbe:
      httpGet:
        path: /
        port: http

    readinessProbe: {}
      httpGet:
        path: /
        port: http
```

## Helm docs

Default values are written using [helm-docs](https://github.com/norwoodj/helm-docs) format.
