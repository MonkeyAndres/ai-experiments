job "ollama" {
  type = "service"

  group "ollama-group" {
    count = 1

    network {
      port "ollama" {
        static = 11434
      }
    }

    service {
      name     = "ollama-svc"
      port     = "ollama"
      provider = "nomad"

      check {
        type     = "tcp"
        port     = "ollama"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "ollama-task" {
      driver = "docker"

      config {
        image = "ollama/ollama"
        ports = ["ollama"]

        volumes = [
          "ollama:/root/.ollama",
        ]
      }

      resources {
        cpu = 1000
        memory = 4096
      }
    }
  }
}