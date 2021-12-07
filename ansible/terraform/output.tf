output "Grafana_URL" {
  value = "http://${aws_instance.udacity.public_dns}:3000"
}

output "Prometheus_URL" {
  value = "http://${aws_instance.udacity.public_dns}:9090"
}

