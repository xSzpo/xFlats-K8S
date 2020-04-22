# xFlat on Kubernetes and GCP [in progress]


**Monitoring and assessment system for flats offers that are put up for sale in Warsaw.**

A service that monitor flats sale offers.
When offer came out, system asses its market value and if the price is attractive sends a message to a user via Telegram messenger.


Keywords
scraper, scrapy, python, kafka, nifi, mongodb, rest api, ml model, xgboost, fastapi, K8S, kubernetes

## commends

ssh
```
gcloud beta compute ssh --zone "us-east1-b" "gke-xszpo3-default-pool-15de7478-jtlx" --project "flats-27
2715" --local-host-port=localhost:8080
```

scale
```
kubectl scale deploy xflats --replicas=0
```
