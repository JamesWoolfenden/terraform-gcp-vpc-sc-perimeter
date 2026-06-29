# terraform-gcp-vpc-sc-perimeter

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter/workflows/Verify/badge.svg?branch=master)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter.svg)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D1.9.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

---

Adds a single enforced (or dry-run) VPC Service Controls perimeter to an existing access policy. Designed for application and data teams who own their project's perimeter but do not manage the org-level policy. Requires an access policy name from `terraform-gcp-vpc-sc-bootstrap` or `terraform-gcp-vpc-sc-policy`.

```terraform
module "vpc_sc_perimeter" {
  source  = "JamesWoolfenden/vpc-sc-perimeter/gcp"
  version = "0.0.1"

  access_policy_name = "1234567890"
  perimeter_name     = "data_platform"

  project_numbers = ["projects/111111111111"]

  restricted_services = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
  ]

  access_level_ip_ranges = ["203.0.113.0/24"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.0.0, < 7.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.0.0, < 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_access_context_manager_access_level.ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_level) | resource |
| [google_access_context_manager_access_level.identities](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_access_level) | resource |
| [google_access_context_manager_service_perimeter.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/access_context_manager_service_perimeter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policy_name"></a> [access\_policy\_name](#input\_access\_policy\_name) | Existing access policy name (output from terraform-gcp-vpc-sc-bootstrap or terraform-gcp-vpc-sc-policy). | `string` | n/a | yes |
| <a name="input_perimeter_name"></a> [perimeter\_name](#input\_perimeter\_name) | Short name for the perimeter (letters, digits, underscores only). | `string` | n/a | yes |
| <a name="input_project_numbers"></a> [project\_numbers](#input\_project\_numbers) | Project numbers to protect (e.g. `['projects/123456789']`). | `list(string)` | n/a | yes |
| <a name="input_restricted_services"></a> [restricted\_services](#input\_restricted\_services) | GCP API endpoints to restrict inside the perimeter. | `list(string)` | `["bigquery.googleapis.com","storage.googleapis.com"]` | no |
| <a name="input_access_level_ip_ranges"></a> [access\_level\_ip\_ranges](#input\_access\_level\_ip\_ranges) | IP ranges allowed to access restricted services. Leave empty to restrict to identities only. | `list(string)` | `[]` | no |
| <a name="input_access_level_identities"></a> [access\_level\_identities](#input\_access\_level\_identities) | Service accounts or users always allowed through (e.g. `serviceAccount:sa@project.iam.gserviceaccount.com`). | `list(string)` | `[]` | no |
| <a name="input_dry_run"></a> [dry\_run](#input\_dry\_run) | When true, perimeter is created in dry-run (spec) mode and never enforced. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_perimeter_name"></a> [perimeter\_name](#output\_perimeter\_name) | Fully qualified perimeter name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Role and Permissions

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "accesscontextmanager.accessLevels.create",
    "accesscontextmanager.accessLevels.delete",
    "accesscontextmanager.accessLevels.get",
    "accesscontextmanager.accessLevels.update",
    "accesscontextmanager.servicePerimeters.create",
    "accesscontextmanager.servicePerimeters.delete",
    "accesscontextmanager.servicePerimeters.get",
    "accesscontextmanager.servicePerimeters.update",
  ]
}
```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

- [terraform-gcp-vpc-sc-bootstrap](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-bootstrap) — First-time VPC-SC setup with dry-run perimeter
- [terraform-gcp-vpc-sc-policy](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-policy) — Full org-wide access policy and perimeter management

## Help

**Got a question?**

File a GitHub [issue](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/JamesWoolfenden/terraform-gcp-vpc-sc-perimeter/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2019-2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150
