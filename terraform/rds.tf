variable "aws_db_username" {}
variable "aws_db_password" {}
variable "database_name" {}

resource "aws_db_instance" "sitename-db" {
  identifier                 = "sitename"
  allocated_storage          = 10
  engine                     = "mysql"
  engine_version             = "5.6.34"
  instance_class             = "db.t2.micro"
  storage_type               = "gp2" # 汎用 (SSD) 小規模から中規模のデータベースに最適
  name                       = "${var.database_name}"
  username                   = "${var.aws_db_username}"
  password                   = "${var.aws_db_password}"
  port                       = 3306
  availability_zone          = "ap-northeast-1a"
  multi_az                   = false
  backup_retention_period    = 1
  backup_window              = "19:00-19:30"
  vpc_security_group_ids     = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.sitename-db-subnet.name}"
  auto_minor_version_upgrade = true
  final_snapshot_identifier  = "sitename-final"
}