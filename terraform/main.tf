# ── Data Sources ──────────────────────────────────────────────────────────────

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ── Key Pair ──────────────────────────────────────────────────────────────────

resource "aws_key_pair" "main" {
  key_name   = "${var.app_name}-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "${var.app_name}-key"
  }
}

# ── Security Groups ───────────────────────────────────────────────────────────

resource "aws_security_group" "ec2" {
  name        = "${var.app_name}-ec2"
  description = "Allow HTTP from anywhere and SSH from my IP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ec2"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.app_name}-rds"
  description = "Allow MySQL only from EC2 security group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  tags = {
    Name = "${var.app_name}-rds"
  }
}

# ── RDS ───────────────────────────────────────────────────────────────────────

resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-db-subnet"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.app_name}-db-subnet"
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.app_name}-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "library_management_production"
  username = "admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible     = false
  multi_az                = false
  skip_final_snapshot     = false
  final_snapshot_identifier = "${var.app_name}-db-final-snapshot"

  tags = {
    Name = "${var.app_name}-db"
  }
}

# ── EC2 ───────────────────────────────────────────────────────────────────────

resource "aws_instance" "main" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = true

  tags = {
    Name = var.app_name
  }
}
