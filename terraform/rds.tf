# Security group for RDS
resource "aws_security_group" "rds" {
  name        = "project-bedrock-rds-sg"
  description = "Allow database access from EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "project-bedrock-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

# RDS MySQL (catalog service)
resource "aws_db_instance" "mysql" {
  identifier           = "project-bedrock-mysql"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "catalog"
  username             = "admin"
  password             = random_password.mysql.result
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  multi_az             = false
}

# RDS PostgreSQL (orders service)
resource "aws_db_instance" "postgresql" {
  identifier           = "project-bedrock-postgresql"
  engine               = "postgres"
  engine_version       = "16"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "orders"
  username             = "dbadmin"
  password             = random_password.postgresql.result
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  multi_az             = false
}

# Random passwords
resource "random_password" "mysql" {
  length  = 16
  special = false
}

resource "random_password" "postgresql" {
  length  = 16
  special = false
}