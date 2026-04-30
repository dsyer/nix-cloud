variable "user" {
  description = "Username of user on remote. Usually `gcloud config list --format 'value(core.account)' | cut -d '@' -f 1`."
}

variable "project" {
  description = "Google Cloud project ID. Discoverable with `gcloud config list --format 'value(core.project)'`"
}

provider "google" {
  project      = var.project
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "default" {
  name         = "test-${random_id.instance_id.hex}"
  machine_type = "c3-standard-8"
  zone         = "us-west1-a"
  metadata = {
    ssh-keys = "${var.user}:${file("~/.ssh/google_compute_engine.pub")}"
  }
  boot_disk {
    initialize_params {
      image = "projects/labsintercon-labsimages/global/images/labs-saas-gcp-centos9-stream-packer-latest"
      size = 100
    }
  }

  network_interface {
    # Use the existing network and subnetwork (by self_link) so the instance
    # attaches to the named network resources rather than the implicit default.
    network    = "projects/ltnz001-saas-vpc/global/networks/ltnz001-vpc"
    subnetwork = "projects/ltnz001-saas-vpc/regions/us-west1/subnetworks/ltnz001-spring-releng-usw1"
    network_ip = "10.31.185.142"
  }

  provisioner "local-exec" {
    command = "./scripts/bootstrap.sh ${var.user}@${google_compute_instance.default.network_interface.0.network_ip}"
  }

}

output "instance_ip" {
    value = "${google_compute_instance.default.network_interface.0.network_ip}"
}

output "instance_name" {
    value = "${google_compute_instance.default.name}"
}