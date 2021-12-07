resource "aws_key_pair" "this" {
  key_name   = "gtrevino-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "udacity" {
  ami                         = "ami-0279c3b3186e54acd"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  availability_zone           = aws_subnet.public.availability_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name

  vpc_security_group_ids = [aws_security_group.this.id]

#  connection {
#    user        = "ubuntu"
#    host        = self.public_ip
#    private_key = file("~/.ssh/id_rsa")
#  }
#
#  provisioner "file" {
#    source      = "../prometheus/prometheus.yml"
#    destination = "/tmp/prometheus.yml"
#  }
#
#  provisioner "file" {
#    source      = "../prometheus/prometheus.service"
#    destination = "/tmp/prometheus.service"
#  }
#
#  provisioner "file" {
#    source      = "../prometheus/node-exporter.service"
#    destination = "/tmp/node-exporter.service"
#  }
#
#  # Install Prometheus in the ubuntu
#  provisioner "remote-exec" {
#    inline = [
#      "sudo useradd --no-create-home prometheus",
#      "sudo mkdir /etc/prometheus",
#      "sudo mkdir /var/lib/prometheus",
#      # Get prometheus
#      "wget https://github.com/prometheus/prometheus/releases/download/v2.19.0/prometheus-2.19.0.linux-amd64.tar.gz",
#      "tar xvfz prometheus-2.19.0.linux-amd64.tar.gz",
#      # Install prometheus
#      "sudo cp prometheus-2.19.0.linux-amd64/prometheus /usr/local/bin",
#      "sudo cp prometheus-2.19.0.linux-amd64/promtool /usr/local/bin/",
#      "sudo cp -r prometheus-2.19.0.linux-amd64/consoles /etc/prometheus",
#      "sudo cp -r prometheus-2.19.0.linux-amd64/console_libraries /etc/prometheus",
#      "sudo cp prometheus-2.19.0.linux-amd64/promtool /usr/local/bin/",
#      # Cleanup
#      "rm -rf prometheus-2.19.0.linux-amd64.tar.gz prometheus-2.19.0.linux-amd64",
#      # Get the configuration files
#      "sudo cp /tmp/prometheus.yml /etc/prometheus/prometheus.yml",
#      "sudo cp /tmp/prometheus.service /etc/systemd/system/prometheus.service",
#      # Setup the service
#      "sudo chown prometheus:prometheus /etc/prometheus",
#      "sudo chown prometheus:prometheus /usr/local/bin/prometheus",
#      "sudo chown prometheus:prometheus /usr/local/bin/promtool",
#      "sudo chown -R prometheus:prometheus /etc/prometheus/consoles",
#      "sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries",
#      "sudo chown -R prometheus:prometheus /var/lib/prometheus",
#      # Start the service
#      "sudo systemctl daemon-reload",
#      "sudo systemctl enable prometheus",
#      "sudo systemctl start prometheus",
#    ]
#  }
#
#  # Install Node Exporter in the ubuntu
#  provisioner "remote-exec" {
#    inline = [
#      "sudo useradd --no-create-home node_exporter",
#      # Get node_exporter
#      "wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz",
#      "tar xzf node_exporter-1.0.1.linux-amd64.tar.gz",
#      "sudo cp node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/node_exporter",
#      "rm -rf node_exporter-1.0.1.linux-amd64.tar.gz node_exporter-1.0.1.linux-amd64",
#      # Get the configuration files
#      "sudo cp /tmp/node-exporter.service /etc/systemd/system/node-exporter.service",
#      # Setup the service
#      # Start the service
#      "sudo systemctl daemon-reload",
#      "sudo systemctl enable node-exporter",
#      "sudo systemctl start node-exporter",
#      "sudo systemctl status node-exporter",
#      "sudo systemctl restart prometheus",
#    ]
#  }

  tags = {
    Name = "Prometheus"
  }
}