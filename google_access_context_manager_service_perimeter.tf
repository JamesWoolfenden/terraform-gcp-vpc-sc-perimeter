
# holden:ignore:HLD_TF_063
resource "google_access_context_manager_service_perimeter" "default" {
  parent                    = "accessPolicies/${var.access_policy_name}"
  name                      = "accessPolicies/${var.access_policy_name}/servicePerimeters/${var.perimeter_name}"
  title                     = var.perimeter_name
  perimeter_type            = "PERIMETER_TYPE_REGULAR"
  use_explicit_dry_run_spec = var.dry_run

  dynamic "spec" {
    for_each = var.dry_run ? [local.perimeter_config] : []
    content {
      resources           = spec.value.resources
      restricted_services = spec.value.restricted_services
      access_levels       = spec.value.access_levels
    }
  }

  dynamic "status" {
    for_each = var.dry_run ? [] : [local.perimeter_config]
    content {
      resources           = status.value.resources
      restricted_services = status.value.restricted_services
      access_levels       = status.value.access_levels
    }
  }

  depends_on = [
    google_access_context_manager_access_level.ip,
    google_access_context_manager_access_level.identities,
  ]
}
