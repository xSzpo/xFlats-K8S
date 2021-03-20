variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_disk_size_gb" {
  default = "30"
  description = "gke disk size"
}

variable "gke_nodes_machine" {
  default     = "n1-standard-4"
  description = "nodes machine type"
}

variable "terraform-sa" {
  default     = "terraform-sa"
  description = "service account prefix - configure earlier"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  #network    = google_compute_network.vpc.name
  #subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    disk_size_gb = var.gke_disk_size_gb
    disk_type    = "pd-standard"
    preemptible  = false
    service_account = "${var.terraform-sa}@${var.project_id}.iam.gserviceaccount.com"

    # preemptible  = true
    machine_type = var.gke_nodes_machine
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}
