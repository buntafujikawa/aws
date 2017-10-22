variable "aws_db_username" {}
variable "aws_db_password" {}
variable "database_name" {}

# https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "sitename-db" {
  identifier                 = "sitename"
  allocated_storage          = 20 # RDS MySQL でサポートされる非プロビジョンドストレージは 20 ～ 6144 GB です
  engine                     = "mysql"
  engine_version             = "5.6.34"
  instance_class             = "db.t2.micro" # 現状の無料プラン
  storage_type               = "gp2" # 汎用 (SSD) 小規模から中規模のデータベースに最適
  name                       = "${var.database_name}"
  username                   = "${var.aws_db_username}"
  password                   = "${var.aws_db_password}"
  port                       = 3306
  availability_zone          = "ap-northeast-1a"
  multi_az                   = false # 料金が倍かかるので必要に応じて
  backup_retention_period    = 3
  backup_window              = "06:00-06:30"
  vpc_security_group_ids     = ["${aws_security_group.rds-sg.id}"]
  db_subnet_group_name       = "${aws_db_subnet_group.sitename-db-subnet.name}"
  auto_minor_version_upgrade = true
  final_snapshot_identifier  = "sitename-final" # _(アンスコ)ダメらしい
  timezone                   = "Asia/Tokyo" # パラメータグループでも変更可能
  character_set_name         = "UTF8" # 初期値のままだとデータの入れ方によってはエラーが発生するので要変更
}