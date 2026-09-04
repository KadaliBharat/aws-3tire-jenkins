# main.tf
resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = { Name = "${var.environment}-db-subnet-group" }
}

resource "aws_db_instance" "primary" {
  identifier             = "${var.environment}-primary-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "appdb"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  skip_final_snapshot    = true
  
  # Required for read replicas
  backup_retention_period = 7
}
