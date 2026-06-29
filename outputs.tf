output "perimeter_name" {
  description = "Fully qualified perimeter name."
  value       = google_access_context_manager_service_perimeter.default.name
}
