terraform {
  required_providers {
    nobl9 = {
      source = "nobl9/nobl9"
      version = "0.6.0"
    }
  }
}

provider "nobl9" {

}

variable "service_name" {
  default = "my-service"
  description = "Name of the service"
  type = string
#  sensitive = true
}

variable "service_description" {
  default = "A wild description"
  description = "Description of the service"
  type = string
  #  sensitive = true
}

resource "nobl9_service" "academy_service" {
  project     = "academy"
  name        = var.service_name
  description = var.service_description
}
