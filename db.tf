resource "aws_db_subnet_group" "rds_subnet" {
  subnet_ids = [ aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id ]
}

resource "aws_db_instance" "wordpress_db" {
  instance_class = "db.t3.micro"
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  db_name = "wordpressdb"
  username = "username"
  password = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.id
  vpc_security_group_ids = [ aws_security_group.RDS_allow_rule.id ]
  multi_az = true
  backup_retention_period = 5
}

resource "aws_db_instance" "replica-wordpress_db" {
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  backup_retention_period = 5
  replicate_source_db = aws_db_instance.wordpress_db.identifier
}