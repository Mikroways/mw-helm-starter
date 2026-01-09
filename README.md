# Mikroways helm charts starter: mw-helm-starter
![Helm Test Status](https://github.com/Mikroways/mw-helm-starter/actions/workflows/helm-chart-linter.yaml/badge.svg)

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
[`multiple-containers`](./multiple-containers) extends `single-container` with multiple containers that can define same configuration but under a container name key. It also adds:

* `jobs`: add same logic for main chart but for specific jobs. It allows to define diferent jobs using a dictionary where key will be used as job name. It also can be used to specify custom annotations to be used for example as helm hooks / argo waves.
* `cronjobs`: same as jobs.
* `extraDeployments`: same as jobs.

For example:

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

cronjobs:
  cronjob1:
    schedule: "* * * * *"
    containers:
      container1:
        image: 
          repository: busybox
        command: ["echo", "Hello from job1 container1"]
      container2:
        image: 
          repository: alpine
          tag: latest
          pullPolicy: Always
        command: ["echo", "Hello from job1 container2"]
        env:
          VAR1: "value1"
          VAR2: "value2"
        config:
          env:
            MY_CRONJOB_VAR1: "cronjob_value1"
            MY_CRONJOB_VAR2: "cronjob_value2"
          secretEnv:
            MY_SECRET_CRONJOB_VAR: "secret_cronjob_value1"
        extraEnvFrom:
          - secretRef:
              name: extra-secret
jobs:
  job1:
    annotations:
      sample_1: "some annotation"
      other.annotation: "other value"
    restartPolicy: Always
    containers:
      container1:
        image: 
          repository: busybox
        command: ["echo", "Hello from job1 container1"]
      container2:
        image: 
          repository: alpine
          tag: latest
          pullPolicy: Always
        command: ["echo", "Hello from job1 container2"]
        env:
          VAR1: "value1"
          VAR2: "value2"
        config:
          env:
            MY_VAR1: "value1"
            MY_VAR2: "value2"
          secretEnv:
            MY_SECRET_VAR: "secret_value1"
        extraEnvFrom:
          - secretRef:
              name: extra-secret
extraDeployments:
  deployment-two:
    imagePullSecrets:
      - name: mysecret   
    containers:
      container1:
        image: 
          repository: nginx
        command: ["nginx", "-g", "daemon off;"]
        persistence:
          data-extra-deployment:
            accessModes:
              - ReadOnlyMany
            annotations:
              example.com/e-deploy-annotation: "other annotation for extra deployment"
            storageClassName: "storageclass"
            resources:
              requests:
                storage: 25Gi
            mountPath: "/data"
          existingData:
            mountPath: "/existing-data"
            existingClaim: "my-existing-pvc"
        extraVolumeMounts:
          - name: my-extra-volume
            mountPath: /my/extra/path
            readOnly: true
    extraVolumes:
      - name: my-extra-volume
        emptyDir: {}
```

## Helm docs

Default values are written using [helm-docs](https://github.com/norwoodj/helm-docs) format. We also provide GH Actions for:

* Lint charts using [helm chart testing](https://github.com/helm/chart-testing)
* Unit test helm charts using [helm unittest plugin](https://github.com/helm-unittest/helm-unittest)

# TODO

* [ ] single container don't implement jobs nor cronjob templates. Single container was created with SPA applications in mind
* [ ] add chart schemas using [helm-schema](https://github.com/dadav/helm-schema)
* [ ] Implement gateway API templates?