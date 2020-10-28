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
  machine_type = "n1-standard-1"
  zone         = "europe-west2-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size = 20
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  provisioner "local-exec" {
    command = "scripts/bootstrap.sh ${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
  }
}

output "instance_ip" {
    value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

output "instance_name" {
    value = "${google_compute_instance.default.name}"
}