# Orfder

1. preprare Prerequisites
2. run terraform:`terraform init & terraform apply`
3. Copy data to cloud storage
4. Load data to bq by running `run_after_tf.sh`


# Sources
* https://cloud.google.com/blog/products/data-analytics/introducing-the-bigquery-terraform-module
* https://learn.hashicorp.com/tutorials/terraform/gke
* https://github.com/gruntwork-io/terraform-google-gke/blob/master/examples/gke-public-cluster/main.tf

# Prerequisites


1. Download the Terraform binary that matches your system type and Terraform installation process.

2. Install Google Cloud SDK on your local machine.

3. Prepare GCP SA and roles
Zmodyfikuj plik z konfiguracja `config_terraform` i skopiuj go do `~/.config/gcloud/configurations/`
`cp config_terraform ~/.config/gcloud/configurations/`
`gcloud config configurations list`
`gcloud config configurations activate terraform`

Złap project ID
`read PROJECT_ID < <(gcloud config get-value project)`
`export SA_ID=terraform-sa`
`export SA_EMAIL=$SA_ID@$PROJECT_ID.iam.gserviceaccount.com`

Aktywuj api BQ
`gcloud services enable bigquery-json.googleapis.com`
`gcloud services enable container.googleapis.com`

Aktywuj k8s api
`gcloud services enable bigquery-json.googleapis.com`


Utworz konto serwisowe
`gcloud iam service-accounts create $SA_ID --display-name $SA_ID`

Nadaj uprawnienia
`
gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/bigquery.dataOwner \
 --user-output-enabled false

gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/compute.instanceAdmin.v1 \
 --user-output-enabled false

gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/compute.serviceAgent \
 --user-output-enabled false

gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/container.admin \
 --user-output-enabled false

 gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/container.serviceAgent \
 --user-output-enabled false

 gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/firebase.admin \
 --user-output-enabled false

 gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/storage.admin \
 --user-output-enabled false

 gcloud projects add-iam-policy-binding $PROJECT_ID \
 --member serviceAccount:$SA_EMAIL\
 --role roles/bigquery.jobUser \
 --user-output-enabled false
`

Sprawdz uprawnienia

gcloud projects get-iam-policy $PROJECT_ID \
--flatten="bindings[].members" \
--format='table(bindings.role)' \
--filter="bindings.members:$SA_EMAIL"


Pobierz klucz
gcloud iam service-accounts keys create ~/secrets/gcp/$SA_ID.json \
 --iam-account $SA_EMAIL \
 --project $PROJECT_ID

 Zapisz gdzie jest klucz:
~/secrets/gcp/terraform-sa.json

upewnij sie, ze poprawna sciezka jest w pliki main.tf


# Learn Terraform - Provision a GKE Cluster

This repo is a companion repo to the [Provision a GKE Cluster learn guide](https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster), containing
Terraform configuration files to provision an GKE cluster on
GCP.

This sample repo also creates a VPC and subnet for the GKE cluster. This is not
required but highly recommended to keep your GKE cluster isolated.

## Install and configure GCloud

First, install the [Google Cloud CLI](https://cloud.google.com/sdk/docs/quickstarts)
and initialize it.

```shell
$ gcloud init
```

Once you've initialized gcloud (signed in, selected project), add your account
to the Application Default Credentials (ADC). This will allow Terraform to access
these credentials to provision resources on GCloud.

```shell
$ gcloud auth application-default login
```

## Initialize Terraform workspace and provision GKE Cluster

Replace `terraform.tfvars` values with your `project_id` and `region`. Your
`project_id` must match the project you've initialized gcloud with. To change your
`gcloud` settings, run `gcloud init`. The region has been defaulted to `us-central1`;
you can find a full list of gcloud regions [here](https://cloud.google.com/compute/docs/regions-zones).

After you've done this, initalize your Terraform workspace, which will download
the provider and initialize it with the values provided in the `terraform.tfvars` file.

```shell
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "google" (hashicorp/google) 3.13.0...
Terraform has been successfully initialized!
```


Then, provision your GKE cluster by running `terraform apply`.

```shell
$ terraform apply

# Output truncated...

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

# Output truncated...

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

kubernetes_cluster_name = dos-terraform-edu-gke
region = us-central1
```

## Configure kubectl

To configure kubetcl, by running the following command.

```shell
$ gcloud container clusters get-credentials dos-terraform-edu-gke --region us-central1
```

The
[Kubernetes Cluster Name](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/gke.tf#L63)
and [Region](https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/master/vpc.tf#L29)
 correspond to the resources spun up by Terraform.

## Deploy and access Kubernetes Dashboard

To deploy the Kubernetes dashboard, run the following command. This will schedule
the resources necessary for the dashboard.

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```

Finally, to access the Kubernetes dashboard, run the following command:

```plaintext
$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

 You should be
able to access the Kubernetes dashboard at [http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/).

## Authenticate to Kubernetes Dashboard

To view the Kubernetes dashboard, you need to provide an authorization token.
Authenticating using `kubeconfig` is **not** an option. You can read more about
it in the [Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#accessing-the-dashboard-ui).

Generate the token in another terminal (do not close the `kubectl proxy` process).

```plaintext
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')

Name:         service-controller-token-m8m7j
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: service-controller
              kubernetes.io/service-account.uid: bc99ddad-6be7-11ea-a3c7-42010a800017

Type:  kubernetes.io/service-account-token

Data
====
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9...
ca.crt:     1119 bytes
```

Select "Token" then copy and paste the entire token you receive into the
[dashboard authentication screen](http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
to sign in. You are now signed in to the dashboard for your Kubernetes cluster.
