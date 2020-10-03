data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_ecs_cluster" "cluster" {
   name = "${var.cluster_name}"

   tags = {
     Name = "${var.name}"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/scripts/user-data.sh")}"

  vars = {
    cluster_name = "${var.cluster_name}"
  }
}

resource "aws_launch_configuration" "lc" {
  image_id             = "${data.aws_ami.ami.id}"
  name_prefix          = "${aws_ecs_cluster.cluster.name}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_role.iam.name}"
  security_groups      = ["${var.security_group_id}"]
  user_data            = "${data.template_file.user_data.rendered}"
  key_name             = "gavin-lego"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.name}-asg"
  vpc_zone_identifier       = ["${var.private_subnet_id}"]
  min_size                  = 1
  max_size                  = 1
  desired_capacity			    = 1
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_configuration      = "${aws_launch_configuration.lc.id}"
  force_delete              = true

  tag = {
     key = "Name"
     value = "${var.name}"
     propagate_at_launch = true
  }
 }