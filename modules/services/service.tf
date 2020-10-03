data "template_file" "task" {
  template = "${file("${path.module}/files/nginx_task_definition.json")}"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.name}"
  container_definitions = "${data.template_file.task.rendered}"
  network_mode          = "bridge"
}


resource "aws_ecs_service" "service" {
  name            = "nginx"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = 3

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "nginx"
    container_port   = 80
  }
}