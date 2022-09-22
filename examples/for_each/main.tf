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

locals {
  services = toset([
    "ingest",
    "web",
    "intake"
  ])
}


resource "nobl9_service" "academy_service" {
  for_each    = local.services
  name        = each.key
  project     = "academy"
}
