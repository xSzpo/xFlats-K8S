terraform {
  required_version = ">= 0.12"
}

variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

provider "google" {
  credentials = file("../secrets/terraform-sa.json")
  project = var.project_id
  region  = var.region
  zone = var.zone
}