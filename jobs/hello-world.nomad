# https://www.nomadproject.io/docs/job-specification
job "hello-world" {
  datacenters = ["dc1"]
  region      = "rg"
  type        = "service"

  group "hello-world" {
    count = 1

    network {
      # give us an available random port which we can refer to as http
      port "http" {
        # resolve our random "http" port to the container port 3000
        to = 3000
      }
    }

    # Specify our service discovery and health check options
    service {
      # defaults to consul, use nomad for service discovery
      provider = "nomad"
      name     = "hello-world"
      port     = "http"

      # https://developer.hashicorp.com/nomad/docs/job-specification/check
      check {
        type     = "http"
        path     = "/"
        interval = "5s"
        timeout  = "2s"
      }
    }

    # Define our workload
    task "hello-world" {
      driver = "docker"
      config {
        image = "chrispruitt/my-static-website"
        ports = ["http"]
      }

      # https://developer.hashicorp.com/nomad/docs/job-specification/env
      env {
        FOO = "BAR"
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256 MB
      }
    }
  }
}
