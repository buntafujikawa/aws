resource "aws_instance" "sitename-web1" {
  ami                         = "ami-374db956" # これちょっと古い
  instance_type               = "t2.micro"
  key_name                    = "ec2_test_keypair" # 自分の環境で作成したkeypairの名前に変更
  vpc_security_group_ids      = ["${aws_security_group.app-sg.id}"]
  subnet_id                   = "${aws_subnet.public-web.id}"
  associate_public_ip_address = true
  monitoring                  = true
  disable_api_termination     = false # 間違って削除をしない設定、重要なインスタンスはtrueにしておいたほうが良い

  tags {
    Name = "sitename_web1"
  }
}

resource "aws_eip" "web1-eip" {
  instance = "${aws_instance.sitename-web1.id}"
  vpc      = true
}

output "elastic_ip_of_web" {
  value = "${aws_eip.web1-eip.public_ip}"
}