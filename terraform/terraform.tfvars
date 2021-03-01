project_id = "coastal-stone"
region     = "europe-west3"
gcs_region = "EUROPE-WEST3"
zone     = "europe-west3-a"


# BQ
#Time that
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