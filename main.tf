#run "gcloud auth application-default login" to authenticate


terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "project-for-vpc-testing"
  region = "me-central2"
  zone   = "me-central2-a"
}

#creating a VPC network for testing
resource "google_compute_network" "vpc_network" {
  name = "cpg-network"
  auto_create_subnetworks = false
}


#creating a private subnet to host servers with data and application
resource "google_compute_subnetwork" "private-subnet" {
  name          = "app-subnetwork"
  ip_cidr_range = "10.10.100.0/24"
  region        = "me-central1"
  network       = google_compute_network.vpc_network.name
  private_ip_google_access = "true"
  }

#creating a public subnet to host server with internet access and IP
resource "google_compute_subnetwork" "public-subnet" {
  name          = "web-subnetwork"
  ip_cidr_range = "10.10.150.0/24"
  region        = "me-central1"
  network       = google_compute_network.vpc_network.name
  private_ip_google_access = "true"
  }


# creating 3 vm instances
resource "google_compute_instance" "app_instance" {
 count = 3
  name         = "app-instance-${count.index}"
  machine_type = "f1-micro"
  zone         = "me-central2-a"
  tags = ["type","app"]
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.private-subnet.name
  }
}

#creating a test bucket

resource "google_storage_bucket" "example_bucket" {
  name     = "cpg-example-bucket-1"
  location = "me-central2"
  force_destroy = true
  project = "project-for-vpc-testing"

  uniform_bucket_level_access = false
}
