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
  credentials = file("~/secrets/gcp/terraform-sa.json")
  project = var.project_id
  region  = var.region
  zone = var.zone
}