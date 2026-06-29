variable "access_policy_name" {
  description = "Existing access policy name (output from terraform-gcp-vpc-sc-bootstrap or terraform-gcp-vpc-sc-policy)."
  type        = string

  validation {
    condition     = length(trimspace(var.access_policy_name)) > 0
    error_message = "access_policy_name must not be empty."
  }
}

variable "perimeter_name" {
  description = "Short name for the perimeter (letters, digits, underscores only)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.perimeter_name))
    error_message = "perimeter_name must start with a letter and contain only letters, digits, and underscores."
  }
}

variable "project_numbers" {
  description = "Project numbers to protect (e.g. ['projects/123456789'])."
  type        = list(string)

  validation {
    condition     = length(var.project_numbers) > 0
    error_message = "project_numbers must contain at least one entry."
  }
  validation {
    condition     = alltrue([for p in var.project_numbers : can(regex("^projects/", p))])
    error_message = "Each project_numbers entry must start with 'projects/'."
  }
}

variable "restricted_services" {
  description = "GCP API endpoints to restrict inside the perimeter."
  type        = list(string)
  default = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
  ]

  validation {
    condition     = alltrue([for s in var.restricted_services : length(trimspace(s)) > 0])
    error_message = "Each restricted service must be a non-empty string."
  }
}

variable "access_level_ip_ranges" {
  description = "IP ranges allowed to access restricted services. Leave empty to restrict to identities only."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.access_level_ip_ranges : length(trimspace(cidr)) > 0])
    error_message = "access_level_ip_ranges must not contain empty strings."
  }
}

variable "access_level_identities" {
  description = "Service accounts or users always allowed through (e.g. 'serviceAccount:sa@project.iam.gserviceaccount.com')."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for i in var.access_level_identities : can(regex("^(serviceAccount:|user:|group:)", i))])
    error_message = "Each identity must start with 'serviceAccount:', 'user:', or 'group:'."
  }
}

variable "dry_run" {
  description = "When true, perimeter is created in dry-run (spec) mode and never enforced."
  type        = bool
  default     = false
}
