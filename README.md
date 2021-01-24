# Mkdocs documentation generator S2i Images


# Features

- Non-root
- Openshift Ready!
- S2i build images

### Deploy Environments 


| Environment | Details |
| ------ | ------ |
| TIMEZONE | Set Timezone (America/Montevideo, America/El_salvador) |


### How use in Openshift

```console

oc process -f https://raw.githubusercontent.com/mvilche/mkdocs-s2i/master/mkdocs-s2i-template.yaml \ 
-p APP_NAME=myapp \
-p REPO_GIT=https://github.com/myuser/mkdocs-project.git
-p SOURCE_SECRET=github | oc create -f -

```


### Generate builder image

```console

 docker build -t mkdocs-s2i -f Dockerfile.builder myapp

```

### Run application

```console

docker run -p 8080:8080 myapp:latest

```

### How use s2i

```console

https://github.com/openshift/source-to-image

```

License
----

Martin vilche
