data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.ami_owners
}

resource "aws_instance" "app_server" {
  ami           = var.custom_ami != "" ? var.custom_ami : data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.node-app-key.key_name
  associate_public_ip_address = true

  security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.http.id}"]
  subnet_id = aws_subnet.dev_app_subnet.id

  user_data_base64 = base64encode(templatefile("${path.module}/${var.provision_script}", {}))

  root_block_device {
    volume_size = 60
  }

  tags = {
    Name = "${local.name}-instance"
  }
}

resource "aws_vpc" "dev_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_subnet" "dev_app_subnet" {
  # The cidrsubnet function takes three arguments(VPC cidr block, number of bits to allocate for the subnet, subnet number)
  cidr_block        = cidrsubnet(aws_vpc.dev_app_vpc.cidr_block, 4, 1)
  vpc_id            = aws_vpc.dev_app_vpc.id
  availability_zone = "${var.region}a"
  tags = {
    Name = "${local.name}-subnet"
  }
}

resource "aws_internet_gateway" "dev_app_igw" {
  vpc_id = aws_vpc.dev_app_vpc.id
}

resource "aws_route_table" "dev_app_route_table" {
  vpc_id = aws_vpc.dev_app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_app_igw.id
  }
}

resource "aws_route_table_association" "dev_app_vpc" {
  subnet_id      = aws_subnet.dev_app_subnet.id
  route_table_id = aws_route_table.dev_app_route_table.id
}

resource "aws_security_group" "ssh" {
  name   = "allow-all"
  vpc_id = aws_vpc.dev_app_vpc.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "http" {
  name = "allow-all-http"

  vpc_id = aws_vpc.dev_app_vpc.id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "node-app-key" {
  key_name   = "node-app-key"
  public_key = file(var.ssh_pub_key)
}


