resource "google_compute_instance" "default" {
  project      = "cf-sandbox-dsyer"
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}