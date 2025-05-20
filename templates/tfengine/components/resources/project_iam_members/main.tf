{{/* Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */}}

{{range  $member := .iam_members_new -}}
module "project_iam_member_{{$member.name}}" {
  source  = "terraform-google-modules/iam/google//modules/member_iam"
  version = "~> 7.7.1"

  service_account_address = split(":","{{$member.member}}")[1]
  project_id              = module.project.project_id
  project_roles           = [
  {{range $r := $member.roles}}
  "{{$r}}",
  {{end}}
  ]
  prefix                  = split(":","{{$member.member}}")[0]
}
{{end -}}
