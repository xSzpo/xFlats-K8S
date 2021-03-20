project_id = "trim-silicon-307221"
sa_name    = "terraform-sa"
region     = "europe-west3"
gcs_region = "EUROPE-WEST3"
zone     = "europe-west3-a"

# GKE
gke_num_nodes = 1
gke_nodes_machine = "n1-standard-4"
terraform-sa = "terraform-sa"
gke_disk_size_gb = "30"

# BQ
time_partitioning = "DAY"
dataset_id = "xflats"
dataset_name = "xflats"
bq_location = "EU"

#The labels for dataset being deployed
dataset_labels = {
  env   = "dev"
  billable   = "true"
  owner = "xszpo"
}

#List of the tables that you are
tables = [
  {
    table_id = "flats",
    schema = "bq_xflats_schema.json",
    labels = {
      env = "dev"
      billable = "true"
      owner = "xszpo"
      offertype = "flats"
    },
  },
]