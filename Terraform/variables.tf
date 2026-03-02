variable "region" {
  default = "us-east-1"
}

variable "app-name" {
  default = "secret-app"
}

variable "cluster-name" {
  default = "secret-cluster"
}

variable "task-family" {
  default = "secret-task-family"
}

variable "container-definitions-file" {
  default = "container-definitions.json"
}

variable "ecs-service-name" {
  default = "secret-app-service"
}

variable "container_port" {
  default = 3000
}

variable "cpu" {
  default = "256"
}

variable "memory" {
  default = "512"
}