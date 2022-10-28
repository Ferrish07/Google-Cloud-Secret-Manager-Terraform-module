output "id" {
  value       = google_secret_manager_secret.this.id
  description = "The fully-qualified id of the Secret Manager key that contains the secret."
}

output "secret_id" {
  value       = google_secret_manager_secret.this.secret_id
  description = "The project-local id Secret Manager key that contains the secret. Should match the input `id`."
}
