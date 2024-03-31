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

    volume "ollama-models" {
      type      = "host"
      read_only = false
      source    = "ollama-models"
    }

    task "ollama-task" {
      driver = "docker"

      config {
        image = "ollama/ollama:rocm"
        ports = ["ollama"]

        devices = [
          {
            host_path      = "/dev/kfd"
            container_path = "/dev/kfd"
          },
          {
            host_path      = "/dev/dri"
            container_path = "/dev/dri"
          }
        ]
      }

      volume_mount {
        volume      = "ollama-models"
        destination = "/root/.ollama"
        read_only   = false
      }

      resources {
        cores  = 8
        memory = 16000
      }
    }
  }
}