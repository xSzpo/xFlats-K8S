#/bin/bash
read -p "Modify file 'config_terraform' with project details i press enter"
echo ">>copy config_terraform and activate it"
cp config_terraform ~/.config/gcloud/configurations/
gcloud config configurations activate terraform

echo ">>set up variables"
export PROJECT_ID=$(gcloud config get-value project| tail -1)
export SA_ID=terraform-sa
export SA_EMAIL=$SA_ID@$PROJECT_ID.iam.gserviceaccount.com
export SA_GCS=gcstorage
export SA_GCS_EMAIL=$SA_GCS@$PROJECT_ID.iam.gserviceaccount.com
export SA_FIRESTORE=gcpfirestore
export SA_FIRESTORE_EMAIL=$SA_FIRESTORE@$PROJECT_ID.iam.gserviceaccount.com

echo ">>activate apis: BQ, container, firestore, cloudresourcemanager"
gcloud services enable bigquery-json.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable firestore.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

echo ">>create SA: $SA_ID" &&
unset tmp &&
export tmp=$(gcloud iam service-accounts list --filter $SA_ID --format="value(displayName)") &&
if [ "$tmp" = "$SA_ID" ]; then echo "sa $SA_ID allready exists"; else gcloud iam service-accounts create $SA_ID --display-name $SA_ID; fi &&
echo ">>add policies to $SA_ID" &&
echo ">>>>roles/bigquery.dataOwner" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/bigquery.dataOwner --user-output-enabled false &&
echo ">>>>roles/compute.instanceAdmin.v1" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/compute.instanceAdmin.v1 --user-output-enabled false &&
echo ">>>>roles/compute.serviceAgent" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/compute.serviceAgent --user-output-enabled false &&
echo ">>>>roles/container.admin" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/container.admin --user-output-enabled false &&
echo ">>>>roles/container.serviceAgent" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/container.serviceAgent --user-output-enabled false &&
echo ">>>>roles/firebase.admin" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/firebase.admin --user-output-enabled false &&
echo ">>>>roles/storage.admin" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/storage.admin --user-output-enabled false &&
echo ">>>>roles/bigquery.jobUser" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role roles/bigquery.jobUser --user-output-enabled false &&
echo ">>save SA key" &&
gcloud iam service-accounts keys create ../secrets/$SA_ID.json --iam-account $SA_EMAIL --project $PROJECT_ID &&
gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:$SA_EMAIL"

echo ">>create SA $SA_GCS" &&
unset tmp &&
export tmp=$(gcloud iam service-accounts list --filter $SA_GCS --format="value(displayName)") &&
if [ "$tmp" = "$SA_GCS" ]; then echo "sa $SA_GCS allready exists"; else gcloud iam service-accounts create $SA_GCS --display-name $SA_GCS; fi &&
echo ">>add policies to $SA_GCS" &&
echo ">>>>roles/storage.admin" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_GCS_EMAIL --role roles/storage.admin --user-output-enabled false &&
gcloud iam service-accounts keys create ../secrets/gcs_key.json --iam-account $SA_GCS_EMAIL --project $PROJECT_ID &&
gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:$SA_GCS_EMAIL"

echo ">>create SA $SA_FIRESTORE" &&
unset tmp &&
export tmp=$(gcloud iam service-accounts list --filter $SA_FIRESTORE --format="value(displayName)") &&
if [ "$tmp" = "$SA_FIRESTORE" ]; then echo "sa $SA_FIRESTORE allready exists"; else gcloud iam service-accounts create $SA_FIRESTORE --display-name $SA_FIRESTORE; fi &&
echo ">>add policies to $SA_FIRESTORE" &&
echo ">>>>rroles/firebase.admin" &&
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_FIRESTORE_EMAIL --role roles/firebase.admin --user-output-enabled false &&
gcloud iam service-accounts keys create ../secrets/gcpfirestore_key.json --iam-account $SA_FIRESTORE_EMAIL --project $PROJECT_ID
gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:$SA_FIRESTORE_EMAIL"
