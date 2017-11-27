resource "aws_alb" "sitename-alb" {
  idle_timeout    = 60
  internal        = false
  name            = "sitename-alb"
  security_groups = ["${aws_security_group.elb-sg.id}"]
  subnets         = ["${aws_subnet.public-web.id}", "${aws_subnet.public-web-staging.id}"]

  enable_deletion_protection = false

  tags {
  }
}
