variable "aws_db_username" {}
variable "aws_db_password" {}
variable "database_production_name" {}
variable "database_staging_name" {}

# https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "sitename-production" {
  identifier                = "sitename-production"
  allocated_storage         = 10 # RDS MySQL でサポートされる非プロビジョンドストレージは 20 ～ 6144 GB です
  storage_type              = "gp2" # 汎用 (SSD) 小規模から中規模のデータベースに最適
  engine                    = "mysql"
  engine_version            = "5.6.34"
  instance_class            = "db.t2.micro" # 現状の無料プラン
  name                      = "${var.database_production_name}"
  username                  = "${var.aws_db_username}"
  password                  = "${var.aws_db_password}"
  port                      = 3306
  publicly_accessible       = false
  availability_zone         = "ap-northeast-1a"
  security_group_names      = []
  vpc_security_group_ids    = ["${aws_security_group.rds-sg.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.sitename-db-subnet.name}"
  parameter_group_name      = "sitename-production"
  multi_az                  = false # 料金が倍かかるので必要に応じて
  backup_retention_period   = 1
  backup_window             = "06:00-06:30"
  maintenance_window        = "thu:05:30-thu:06:00"
  final_snapshot_identifier = "sitename-production-final" # _(アンスコ)ダメらしい
  timezone                   = "Asia/Tokyo" # パラメータグループでも変更可能
  character_set_name         = "UTF8" # 初期値のままだとデータの入れ方によってはエラーが発生するので要変更
}
resource "aws_db_instance" "sitename-staging" {
  identifier                = "sitename-staging"
  allocated_storage         = 10
  storage_type              = "standard"
  engine                    = "mysql"
  engine_version            = "5.6.34"
  instance_class            = "db.t2.micro"
  name                      = "${var.database_staging_name}"
  username                  = "${var.aws_db_username}"
  password                  = "${var.aws_db_password}"
  port                      = 3306
  publicly_accessible       = false
  availability_zone         = "ap-northeast-1a"
  security_group_names      = []
  vpc_security_group_ids    = ["${aws_security_group.rds-sg.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.sitename-db-subnet.name}"
  parameter_group_name      = "default.mysql5.6"
  multi_az                  = false
  backup_retention_period   = 1
  backup_window             = "06:00-06:30"
  maintenance_window        = "thu:05:30-thu:06:00"
  final_snapshot_identifier = "sitename-staging-final"
  timezone                   = "Asia/Tokyo"
  character_set_name         = "UTF8"
}
