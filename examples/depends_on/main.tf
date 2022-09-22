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
  project     = "academy"
  name        = "my-service"
}

resource "nobl9_agent" "academy-prometheus" {
  project = "academy"
  name = "prometheus"
  source_of = ["Metrics"]
  agent_type = "prometheus"

  prometheus_config {
    url = "http://web.net"
  }
}

resource "nobl9_slo" "academy_slo" {
  name             = "my-cool-slo"
  service          = "my-service"
  budgeting_method = "Occurrences"
  project          = "academy"

#  depends_on is added because SLO needs data source to be configured beforehand
#  If customer tries to applies an SLO without the data source, it will result in an error
#  -------------------------------------------------------------------
# nobl9_service.academy_service: Creating...
# nobl9_agent.academy-prometheus: Creating...
# nobl9_slo.academy_slo: Creating...
# nobl9_service.academy_service: Creation complete after 1s [id=my-service]
# nobl9_agent.academy-prometheus: Creation complete after 2s [id=prometheus]
#╷
#│ Error: could not add SLO: applying SLO my-cool-slo in 'academy' project failed, because object Agent prometheus referenced in its spec does not exist in 'academy' project
#│
#│   with nobl9_slo.academy_slo,
#│   on main.tf line 36, in resource "nobl9_slo" "academy_slo":
#│   36: resource "nobl9_slo" "academy_slo" {
#│
#╵
#  -------------------------------------------------------------------
    depends_on = [nobl9_agent.academy-prometheus]

  time_window {
    unit       = "Day"
    count      = 14
    is_rolling = true
  }

  objective {
    target       = 0.999
    value        = 5
    display_name = "what"
    op           = "lte"

    raw_metric {
      query {
        prometheus {
          promql = "elo"
        }
      }
    }
  }

  indicator {
    name    = "prometheus"
    kind    = "Agent"
    project = "academy"
  }
}