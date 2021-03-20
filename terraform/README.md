# Prerequisites
1. Download the Terraform binary that matches your system type and Terraform installation process.
2. Install Google Cloud SDK on your local machine.
3. Prepare GCP SA and roles
  1. Write gcp project details into `config_terraform`
  2. Configure gcloud, wnable google apis, create Service Accounts,`terraform_prerequirement.sh`
  3. Plan terraform:`terraform init & terraform plan`
  4. Apply terraform:`terraform init & terraform apply`
  5. Copy data to cloud storage
  6. Load data to bq by running `run_after_tf.sh`


# Sources

* https://cloud.google.com/blog/products/data-analytics/introducing-the-bigquery-terraform-module
* https://learn.hashicorp.com/tutorials/terraform/gke
* https://github.com/gruntwork-io/terraform-google-gke/blob/master/examples/gke-public-cluster/main.tf
