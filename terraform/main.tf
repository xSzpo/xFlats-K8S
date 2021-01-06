variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gcs_region" {
  description = "gcs_region"
}

variable "zone" {
  description = "zone"
}

provider "google" {
  credentials = file("/Users/xszpo/secrets/gcp/terraform-coastal-stone-28f786ffe859.json")
  project = var.project_id
  region  = var.region
  zone = var.zone
}