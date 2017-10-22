resource "aws_vpc" "vpc-main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name = "vpc-main"
  }
}

# subnetはpublic用とprivate用を各regionに作成する

# subnet public
resource "aws_subnet" "public-web" {
  # aws_* といった接頭辞があらかじめ Terraform 側で定義されているためaws_vpcで指定可能
  vpc_id                  = "${aws_vpc.vpc-main.id}"
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags {
    Name = "public-web"
  }
}

resource "aws_subnet" "public-web2" {
  vpc_id                  = "${aws_vpc.vpc-main.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags {
    Name = "public-web2"
  }
}

# subnet private
resource "aws_subnet" "private-db" {
  vpc_id            = "${aws_vpc.vpc-main.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "private-db"
  }
}

resource "aws_subnet" "private-db2" {
  vpc_id            = "${aws_vpc.vpc-main.id}"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  tags {
    Name = "private-db2"
  }
}

# subnet db
resource "aws_db_subnet_group" "sitename-db-subnet" {
  name        = "sitename-db"
  description = "sitename-rds-group"
  subnet_ids  = ["${aws_subnet.private-db.id}", "${aws_subnet.private-db2.id}"]
}

# internet gateway
resource "aws_internet_gateway" "gateway-for-sitename" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  tags {
    Name = "gateway-for-sitename"
  }
}

# route table
# TODO 作成したルートテーブルをメインにする設定を入れる必要が有る
resource "aws_route_table" "vpc-main-public-rtb" {
  vpc_id = "${aws_vpc.vpc-main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway-for-sitename.id}"
  }
  tags {
    Name = "vpc-main-public-rtb"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = "${aws_subnet.public-web.id}"
  route_table_id = "${aws_route_table.vpc-main-public-rtb.id}" # publicのsubnetのみを紐付けるようにする
}