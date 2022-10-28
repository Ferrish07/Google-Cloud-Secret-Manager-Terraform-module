terraform {
  required_version = ">= 0.13"
}

resource "random_password" "this" {
  count       = var.secret == "" ? 1 : 0
  length      = var.length
  number      = var.has_numeric_chars
  min_numeric = var.min_numeric_chars
  upper       = var.has_upper_chars
  min_upper   = var.min_upper_chars
  lower       = var.has_lower_chars
  min_lower   = var.min_lower_chars
  special     = var.has_special_chars
  min_special = var.min_special_chars
}

resource "google_secret_manager_secret" "this" {
  project   = var.project
  secret_id = var.secret_id
  labels    = var.labels
  replication {
    dynamic "user_managed" {
      for_each = length(var.replication_locations) > 0 ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication_locations
          content {
            location = replicas.value
          }
        }
      }
    }
    automatic = length(var.replication_locations) > 0 ? null : true
  }
}

resource "google_secret_manager_secret_version" "this" {
  secret      = google_secret_manager_secret.this.id
  secret_data = var.secret != "" ? var.secret : random_password.this[0].result
}

resource "google_secret_manager_secret_iam_member" "this" {
  for_each  = toset(var.accessors)
  project   = var.project
  secret_id = google_secret_manager_secret.this.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}
