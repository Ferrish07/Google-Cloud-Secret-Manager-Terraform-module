# Secret Manager for Terraform

> NOTE: This module is for Terraform 0.13 and newer.

This module provides an opinionated wrapper around creating and managing secret values
in GCP [Secret Manager](https://cloud.google.com/secret-manager) with Terraform
0.13 and newer.

This has been "borrowed" from Google's Terraform module and I've just simplified it a bit.

Given a project identifier, the module will create a new secret, or update an
existing secret version, so that it contains the value provided. An optional list
of IAM user, group, or service account identifiers can be provided and each of
the identifiers will be granted `roles/secretmanager.secretAccessor`.

> NOTE: This module can create the Secret Manager payload could be a security risk! The secret payload will be stored in the Terraform state. Please ensure you have the correct security and IAM in place for any remote or local Terraform state.

This module can be refactored to not include the secret payload and just create the Google Cloud Secret Manager ID.

```hcl
module "secret" {
  source     = "./secret_manager"
  project    = "my-project-id"
  id         = "my-secret"
  secret     = "T0pS3cret!"
  accessors  = ["group:team@example.com"]
}
```

Omitting the `var.secret` will use the random_password resource to create a secret with a
generated value.

```hcl
module "secret" {
  source     = "./secret_manager"
  project             = "my-project-id"
  id                  = "my-secret"
  length              = 12
  min_lower_chars     = 5
  min_upper_chars     = 4
  min_numeric_chars   = 2
  min_special_chars   = 1
  accessors  = ["group:team@example.com", "serviceAccount:service-account@project.iam.gserviceaccount.com"]
}
```

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accessors"></a> [accessors](#input\_accessors) | An optional list of IAM account identifiers that will be granted accessor (read-only)<br>permission to the secret. | `list(string)` | `[]` | no |
| <a name="input_secrey_id"></a> [secret_id](#input\_id) | The secret identifier to create; this value must be unique within the project. | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | An optional map of label key:value pairs to assign to the secret resources.<br>Default is an empty map. | `map(string)` | `{}` | no |
| <a name="input_project"></a> [project](#input\_project\_id) | The GCP project identifier where the secret will be created. | `string` | n/a | yes |
| <a name="input_replication_locations"></a> [replication\_locations](#input\_replication\_locations) | An optional list of replication locations for the secret. If the value is an<br>empty list (default) then an automatic replication policy will be applied. Use<br>this if you must have replication constrained to specific locations.<br><br>E.g. to use automatic replication policy (default)<br>replication\_locations = []<br><br>E.g. to force secrets to be replicated only in us-east1 and us-west1 regions:<br>replication\_locations = [ "us-east1", "us-west1" ] | `list(string)` | `[]` | no |
| <a name="input_secret"></a> [secret](#input\_secret) | The secret payload to store in Secret Manager. Binary values should be base64<br>encoded before use. | `string` | n/a | yes |
| <a name="input_length"></a> [length](#input\_length) | The length of the random string to generate for secret value. Default is 16. | `number` | n/a | no |
| <a name="input_has_lower_chars"></a> [has_lower_chars](#input\_has_lower_chars) | Include lowercase characters in the generated secret. | `bool` | n/a | no |
| <a name="input_min_lower_chars"></a> [min_lower_chars](#input\_min_lower_chars) | The minimum number of lowercase characters to include in the generated secret. | `number` | n/a | no |
| <a name="input_has_upper_chars"></a> [has_upper_chars](#input\_has_upper_chars) | Include uppercase characters in the generated secret. | `bool` | n/a | no |
| <a name="input_min_upper_chars"></a> [min_upper_chars](#input\_min_upper_chars) | The minimum number of uppercase characters to include in the generated secret. | `number` | n/a | no |
| <a name="input_has_numeric_chars"></a> [has_numeric_chars](#input\_has_numeric_chars) | Include numeric characters in the generated secret. | `bool` | n/a | no |
| <a name="input_min_numeric_chars"></a> [min_numeric_chars](#input\_min_numeric_chars) | The minimum number of numeric characters to include in the generated secret. | `number` | n/a | no |
| <a name="input_has_special_chars"></a> [has_special_chars](#input\_has_special_chars) | Include special characters in the generated secret. | `bool` | n/a | no |
| <a name="input_min_special_chars"></a> [min_special_chars](#input\_min_special_chars) | The minimum number of specialß characters to include in the generated secret. | `number` | n/a | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The fully-qualified id of the Secret Manager key that contains the secret. |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The project-local id Secret Manager key that contains the secret. Should match<br>the input `id`. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- markdownlint-enable MD033 MD034 -->
