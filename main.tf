variable "AAP_TOKEN" {
  description = "The Bearer Token for Ansible Automation Platform"
  type        = string
  sensitive   = true # This hides the value from CLI output/logs
}

variable "AAP_HOST" {
  description = "The URL of your AAP instance"
  type        = string
}

variable "JOB_ID" {
  description = "The ID of the Job Template to launch"
  type        = string
}

terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.1.0"
    }
  }
}

resource "terracurl_request" "trigger_ansible" {
  name           = "trigger_aap_job"
  url            = "${var.AAP_HOST}/api/v2/job_templates/${var.JOB_ID}/launch/"
  method         = "POST"
  
  headers = {
    Authorization = "Bearer ${var.AAP_TOKEN}"
    Content-Type  = "application/json"
  }

  # We send an empty JSON body to trigger the launch
  request_body = jsonencode({})

  # Expecting 201 Created from AAP
  response_codes = [201]
}
