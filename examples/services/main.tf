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

# Usually we could create this
# but for it's already created for the duration of Academy
#resource "nobl9_project" "academy_project" {
#  name = "academy"
#}

resource "nobl9_service" "academy_service" {
  project = "academy"
  name = "my-service"
}
