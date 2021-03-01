resource "google_storage_bucket" "flats" {
  name          = "${var.project_id}-flats"
  location      = var.gcs_region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access  = true
}

resource "google_storage_bucket" "plots" {
  name          = "${var.project_id}-plots"
  location      = var.gcs_region
  force_destroy = true
  storage_class = "STANDARD"
  uniform_bucket_level_access  = true
}


resource "local_file" "foo" {
    content     = "${google_storage_bucket.flats.name}, ${google_storage_bucket.plots.name},"
    filename = "${path.module}/bucket_names.txt"
}

output "google_storage_bucket_flats" {
  value       = google_storage_bucket.flats.name
  description = "Storage bucket"
}

output "google_storage_bucket_plots" {
  value       = google_storage_bucket.plots.name
  description = "Storage bucket"
}
