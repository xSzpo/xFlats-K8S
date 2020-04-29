# xFlat on Kubernetes and GCP [in progress]


**Monitoring and assessment system for flats offers that are put up for sale in Warsaw.**

A service that monitor flats sale offers.
When offer came out, system asses its market value and if the price is attractive sends a message to a user via Telegram messenger.


Keywords
scraper, scrapy, python, kafka, nifi, mongodb, rest api, ml model, xgboost, fastapi, K8S, kubernetes

## commends

### GCP

create cluster
```
gcloud beta container --project "flats-272715" clusters create "xszpo2" --zone "us-east1-b" --no-enable-basic-auth --release-channel "rapid" --machine-type "g1-small" --image-type "COS" --disk-type "pd-standard" --disk-size "30" --node-labels app=xflats --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --no-enable-stackdriver-kubernetes --enable-ip-alias --network "projects/flats-272715/global/networks/default" --subnetwork "projects/flats-272715/regions/us-east1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair
```

ssh
```
gcloud beta compute ssh --zone "us-east1-b" "gke-xszpo3-default-pool-15de7478-jtlx" --project "flats-27
2715" --local-host-port=localhost:8080
```

up
```
# bedfore start modify kustomization.yaml (uncomment disk creation od GCP, comment dick creation on local)
kubectl apply -k .
kubectl apply -f deployment_gcp.yaml

### Local
# bedfore start modify kustomization.yaml (comment disk creation od GCP, uncomment dick creation on local)
kubectl apply -k .
kubectl apply -f deployment_gcp.yaml

### All

scale
```
kubectl scale deploy xflats --replicas=0
```
