resource "google_storage_bucket" "flats" {
  name          = "${var.project_id}-flats"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access  = true
}

resource "google_storage_bucket" "plots" {
  name          = "${var.project_id}-plots"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access  = true
}

output "google_storage_bucket_flats" {
  value       = "gs://${google_storage_bucket.flats.name}/"
  description = "Storage bucket"
}

output "google_storage_bucket_plots" {
  value       = "gs://${google_storage_bucket.plots.name}/"
  description = "Storage bucket"
}

resource "local_file" "foo" {
    content     = "${google_storage_bucket.flats.name}, ${google_storage_bucket.plots.name},"
    filename = "${path.module}/bucket_names.txt"
}