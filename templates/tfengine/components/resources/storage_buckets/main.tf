{{- /* Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */ -}}

{{range get . "storage_buckets"}}
module "{{resourceName . "name"}}" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 1.4"

  name       = "{{.name}}"
  project_id = module.project.project_id
  location   = "{{get . "storage_location" $.storage_location}}"
  {{hclField . "force_destroy"}}
  {{if $labels := merge (get $ "labels") (get . "labels") -}}
  labels = {
    {{range $k, $v := $labels -}}
    {{$k}} = "{{$v}}"
    {{end -}}
  }
  {{end -}}

  {{if has . "lifecycle_rules" -}}
  lifecycle_rules = [
    {{range .lifecycle_rules -}}
    {
      action = {
        type = "{{.action.type}}"
        {{hclField .action "storage_class" -}}
      }
      condition = {
        {{hclField .condition "age" -}}
        {{hclField .condition "created_before" -}}
        {{hclField .condition "with_state" -}}
        {{hclField .condition "matches_storage_class" -}}
        {{hclField .condition "num_newer_versions" -}}
        {{hclField .condition "matches_prefix" -}}
        {{hclField .condition "matches_suffix" -}}
      }
    }
    {{end -}}
  ]
  {{end -}}

  {{if has . "retention_policy" -}}
  retention_policy = {
    is_locked        = {{get . "retention_policy.is_locked" false}}
    retention_period = {{.retention_policy.retention_period}}
  }
  {{end -}}

  {{ if index . "iam_members"}}
  {{hclField . "iam_members" -}}
  depends_on = [
    {{range $m := .iam_members}}
    {{ if index $m "depends_on"}}
    {{range $d := $m.depends_on}}
  "{{$d}}",
  {{end}}
  {{end}}
  {{end}}
  ]
  {{end}}
}
{{end -}}
