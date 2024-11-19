terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  region  = "me-central2"
  zone    = "me-central2-a"
}

resource "google_compute_network" "example_network"{
  name                            = "example-network-1"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 100
  project                         = "ipd-sample-gke-autopilot"
}

resource "google_container_node_pool" "example_node_pool" {
  name               = "example-node-pool-1"
  cluster            = "example-cluster-1"
  project            = "ipd-sample-gke-autopilot"
  initial_node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
  }
}

resource "google_storage_bucket" "example_bucket" {
  name          = "cpg-example-bucket-1"
  location      = "me-central2"
  force_destroy = true

  project = "ipd-sample-gke-autopilot"

  uniform_bucket_level_access = false
}
