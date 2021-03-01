variable "expiration" {
  description = "TTL of tables using the dataset in MS"
  default     = null
}

variable "time_partitioning" {
  description = "Configures time-based partitioning for this table"
}

variable "dataset_labels" {
  description = "A mapping of labels to assign to the table"
  type        = map(string)
}

variable "tables" {
  description = "A list of maps that includes both table_id and schema in each element, the table(s) will be created on the single dataset"
  default     = []
  type        = list(object({
    table_id  = string,
    schema    = string,
    labels    = map(string),
}))
}


variable "dataset_id" {
  description = "dataset_id id"
}

variable "dataset_name" {
  description = "dataset_name id"
}

variable "bq_location" {
  description = "dataset_name id"
}

module "bigquery" {
  source            = "terraform-google-modules/bigquery/google" # Path to the module
  version           = "~> 2.0.0" # Specify the version of the module you require
  dataset_id        = var.dataset_id
  dataset_name      = var.dataset_name
  description       = "web-scraped flats offers" # updated the description accordingly
  expiration        = var.expiration
  project_id        = var.project_id
  location          = var.bq_location # Update location if needed
  tables            = var.tables
  time_partitioning = var.time_partitioning
  dataset_labels    = var.dataset_labels
}

#bq show --format=prettyjson -j load_flats
#BigQuery Data Transfer API


output "google_bq_dataset" {
  value       =  var.dataset_id
  description = "BQ Dataset Name"
}

output "google_bq_flat_table" {
  value       = var.tables[0].table_id
  description = "BQ Dataset Name"
}


/*
resource "random_id" "id" {
	  byte_length = 8
}

resource "google_bigquery_job" "job" {
  job_id     = "load-${random_id.id.hex}"
  location   = var.bq_location

  labels = {
    "my_job" ="load"
  }

  load {
    source_uris = [
      "gs://coastal-stone-flats/flats_all*",
    ]

    destination_table {
      project_id = var.project_id
      dataset_id = var.dataset_id
      table_id   = var.tables[0].table_id
    }

    source_format = "NEWLINE_DELIMITED_JSON"
    max_bad_records = 30
    ignore_unknown_values = true
    write_disposition = "WRITE_APPEND"

  }
}

resource "local_file" "bqoutput" {
    content  = "${google_bigquery_job.job.id}"
    filename = "${path.module}/job_names.txt"
}
*/
