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

resource "nobl9_service" "academy_service" {
  project = "academy"
  name    = "my-service"

  # 1 - WRONG TYPE
  # will throw type validation error
  # ----------------------------------------------------------------------
  #  Error: Incorrect attribute value type
  #│
  #│   on main.tf line 27, in resource "nobl9_service" "academy_service":
  #│   27:     values = "vast and infinite"
  #│
  #│ Inappropriate value for attribute "values": list of string required.
  # ----------------------------------------------------------------------
#  label {
#    key = "net"
#    values = "vast and infinite"
#  }

  # 2 - EMPTY KEY
  # will throw custom validation error
  # ----------------------------------------------------------------------
  #  Error: key must not be empty
  #│
  #│   with nobl9_service.academy_service,
  #│   on main.tf line 48, in resource "nobl9_service" "academy_service":
  #│   48:     key = ""
  # ----------------------------------------------------------------------
#  label {
#    key = ""
#    values = ["vast", "infinite"]
#  }

  # 3 - DUPLICATE KEYS
  #will throw error while applying but before accessing API
  # ----------------------------------------------------------------------
  #nobl9_service.academy_service: Creating...
  #╷
  #│ Error: duplicate label key [net] found - expected only one occurrence of each label key
  #│
  #│   with nobl9_service.academy_service,
  #│   on main.tf line 20, in resource "nobl9_service" "academy_service":
  #│   20: resource "nobl9_service" "academy_service" {
  # ----------------------------------------------------------------------
#  label {
#    key = "net"
#    values = ["vast", "infinite"]
#  }
#
#  label {
#    key = "net"
#    values = ["vast", "infinite"]
#  }

  # 4 - INVALID KEY VALUE - API ERROR
  #will throw error while applying, after calling API
  # ----------------------------------------------------------------------
  #  nobl9_service.academy_service: Modifying... [id=my-service]
  #│ Error: could not add service: Key: 'Service.ObjectHeader.MetadataHolder.metadata.labels' Error:Field validation for 'labels' failed on the 'labels' tag
  #│
  #│   with nobl9_service.academy_service,
  #│   on main.tf line 20, in resource "nobl9_service" "academy_service":
  #│   20: resource "nobl9_service" "academy_service" {
  # ----------------------------------------------------------------------
#  label {
#    key = "2net"
#    values = ["vast", "infinite"]
#  }
}
