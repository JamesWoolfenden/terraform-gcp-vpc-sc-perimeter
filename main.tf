locals {
  has_ip_level       = length(var.access_level_ip_ranges) > 0
  has_identity_level = length(var.access_level_identities) > 0
  access_level_names = concat(
    local.has_ip_level ? [google_access_context_manager_access_level.ip[0].name] : [],
    local.has_identity_level ? [google_access_context_manager_access_level.identities[0].name] : [],
  )
  perimeter_config = {
    resources           = var.project_numbers
    restricted_services = var.restricted_services
    access_levels       = local.access_level_names
  }
}

resource "google_access_context_manager_access_level" "ip" {
  count  = local.has_ip_level ? 1 : 0
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/${var.perimeter_name}_ip"
  title  = "${var.perimeter_name} — allowed IP ranges"

  basic {
    conditions {
      ip_subnetworks = var.access_level_ip_ranges
    }
  }
}

resource "google_access_context_manager_access_level" "identities" {
  count  = local.has_identity_level ? 1 : 0
  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/${var.perimeter_name}_identities"
  title  = "${var.perimeter_name} — allowed identities"

  basic {
    conditions {
      members = var.access_level_identities
    }
  }
}

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
