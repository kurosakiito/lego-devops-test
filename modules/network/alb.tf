resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg.id}"]
  subnets            = ["${aws_subnet.public.*.id}"]

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_target_group" "hello" {
  name     = "${var.name}-target-group-hello"
  port     = 81
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_target_group" "text" {
  name     = "${var.name}-target-group-text"
  port     = 82
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    forward {
      target_group {
        arn = "${aws_lb_target_group.target_group.arn}"
        weight = 33
      }

      target_group {
        arn = "${aws_lb_target_group.hello.arn}"
        weight = 33 
      }

      target_group {
        arn = "${aws_lb_target_group.text.arn}"
        weight = 33
      }

      stickiness {
        enabled  = false
        duration = 1
      }
      
    }
  }
}