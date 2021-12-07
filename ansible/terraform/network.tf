resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.project_name} VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.aws_region
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name} Subnet"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name} IGW"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.all_traffic_cidr
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name} RouteTable"
  }
}

#resource "aws_route" "main_default" {
#  route_table_id         = aws_route_table.this.id
#  destination_cidr_block = "${var.all_traffic_cidr}"
#  gateway_id             = aws_internet_gateway.this.id
#}

resource "aws_main_route_table_association" "this" {
  #subnet_id      = [aws_subnet.public.id]
  route_table_id = aws_route_table.this.id
  vpc_id         = aws_vpc.this.id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = [aws_subnet.public.id]

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = var.all_traffic_cidr
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = var.all_traffic_cidr
  }

  tags = {
    Name = "${var.project_name} Public Subnets"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg"
  description = "${var.project_name} Security Group"
  vpc_id      = aws_vpc.this.id

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.port_22_cidr]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.port_80_cidr]
  }

  // To Allow Port 3000 Transport - Prometheus
  ingress {
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = [var.port_3000_cidr]
  }

  // To Allow Port 9090 Transport - Prometheus
  ingress {
    from_port   = 9090
    protocol    = "tcp"
    to_port     = 9090
    cidr_blocks = [var.port_9090_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic_cidr]
  }

  lifecycle {
    create_before_destroy = true
  }
}
