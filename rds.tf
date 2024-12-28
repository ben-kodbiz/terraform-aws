# ==============================================================================
# RDS MySQL Database
# ==============================================================================

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_db_subnet_a.id]

    tags = {
    Name = "db-subnet-group"
  }
}

resource "aws_db_instance" "main_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0" # Check AWS console for latest version
  instance_class       = "db.t3.micro" # Change to appropriate instance type
  db_name              = "main-db" # Correct attribute to set database name
  username             = var.db_username  # Change to your desired username
  password             = var.db_password_plain # Store this using secret manager
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot  = true
  multi_az             = false  #Set this to true in production
    publicly_accessible = false # Ensure this is false
      storage_encrypted     = true # Ensure this is true
   tags = {
    Name = "main-db"
  }

}