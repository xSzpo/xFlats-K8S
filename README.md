# xFlat on Kubernetes and GCP

# Overview

Monitoring and assessment system for housing market.
It looks for new offers of houses and plots within 15 minutes intervals.
sFlats utilizes GCP cloud solutions and Kubernetes.
An on-prem version, build with different technologies is available [here](https://github.com/xSzpo/xFlats).

In progres:
* flats price assesment (ml model with Rest Api)

Keywords:
`scraper`, `scrapy`, `python`, `firestore`, `redis`, `luigi`, `rest api`, `xgboost`, `telegram`,

</br>


## Start
Autorize cloud sdk: `gcloud auth login` or `gcloud auth application-default login`.


## Setup infrastructure and deploy app
</br>

### Infrastructure - Terraform
</br>

Create service accounts, GKE cluster, GCS buckets, Firestore DB, BQ Wharehouse, using terraform scripts from `./terraform`. Details are described in `README.md` file.

</br>

### Deploy on GKE


1. Modify file kustomization.yaml (uncomment disk creation od GCP, comment disk creation on local env).

2. Create secrets, config maps, create volumes.
```
kubectl apply -k .
```

2. Update values in `deployment_gcp.yaml`:
* bucket names `LUIGI_BUCKET`, `LUIGI_BUCKET_PLOTS`,
* secret names (you can get it usuing `kubectl get secrets`) ex. `secretName: telegram-5bb96t2mf8`,
* persistance volumes claim names: ex. `claimName: pv-gcp-scraper-plots-claim`


3. Deploy on GCP:
```
kubectl apply -f deployment_gcp.yaml
```

</br>

### Deploy localy

Modify file `kustomization.yaml` (comment disk creation od GCP, uncomment disk creation on local env).

The rest is similar as in previouse sections.

</br>

### Cheatsheet

scale
```
kubectl scale deploy `cluster name` --replicas=0
```

copy from/to container
```
kubectl cp default/xflats-58695565f8-rkj9l:/data/redis/redis_dump.rdb redis_dump.rdb -c redis

kubectl cp redis_dump.rdb default/xflats-597995dd96-9mwzr:/data/redis/redis_dump.rdb
```

log into container
``
kubectl exec -it xflats-664bdcbc5b-l8m9s -c luigi /bin/sh
``
