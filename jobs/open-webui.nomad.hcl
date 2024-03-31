job "open-webui" {
  type = "service"

  group "open-webui" {
    count = 1

    network {
      port "webui" {
        static = 3000
        to = 8080
      }
    }

    task "open-webui" {
      driver = "docker"

      // Template stanza to dynamically set OLLAMA_BASE_URL
      template {
        data = <<EOH
    {{ range nomadService "ollama-svc" }}
    OLLAMA_BASE_URL=http://{{ .Address }}:{{ .Port }}
    {{ end }}
    EOH
        destination = ".env"
        env = true
      }

      config {
        image = "ghcr.io/open-webui/open-webui:main"
        ports = ["webui"]

        volumes = [
          "open-webui:/app/backend/data",
        ]
      }

      resources {
        cpu = 1000
        memory = 4096
      }

      service {
        name = "open-webui"
        port = "webui"
        provider = "nomad"
      }
    }
  }
}