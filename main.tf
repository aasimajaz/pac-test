terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  region = "me-central2"
  zone   = "me-central2-a"
}

resource "google_compute_network" "example_network" {
  name                            = "example-network-1"
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 1300
  project                         = "project-for-vpc-testing"
}


resource "google_storage_bucket" "example_bucket" {
  name     = "cpg-example-bucket-1"
  location = "me-central2"
  force_destroy = true
  project = "project-for-vpc-testing"

  uniform_bucket_level_access = false
}
