resource "aws_instance" "sitename-production1" {
  ami                         = "ami-374db956" # これちょっと古い
  availability_zone           = "ap-northeast-1a"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = "ec2_test_keypair"
  subnet_id                   = "${aws_subnet.public-web.id}"
  vpc_security_group_ids      = ["${aws_security_group.app-sg.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.0.84"
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags {
    "Name" = "sitename-production1"
  }
}

resource "aws_instance" "sitename-staging" {
  ami                         = "ami-2a69be4c"
  availability_zone           = "ap-northeast-1c"
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = true
  key_name                    = "ec2_test_keypair"
  subnet_id                   = "${aws_subnet.public-web-staging.id}"
  vpc_security_group_ids      = ["${aws_security_group.app-sg.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.1.24"
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags {
    "Name" = "sitename-staging"
  }
}

resource "aws_eip" "sitename-production1-eip" {
  instance = "${aws_instance.sitename-production1.id}"
  vpc      = true
}

resource "aws_eip" "sitename-staging-eip" {
  instance = "${aws_instance.sitename-staging.id}"
  vpc      = true
}

output "elastic_ip_of_production" {
  value = "${aws_eip.sitename-production1-eip.public_ip}"
}

output "elastic_ip_of_staging" {
  value = "${aws_eip.sitename-staging-eip.public_ip}"
}