data "template_file" "task" {
  template = "${file("${path.module}/files/service_task_definition.json")}"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.name}"
  container_definitions = "${data.template_file.task.rendered}"
  network_mode          = "bridge"
}


resource "aws_ecs_service" "service" {
  name            = "${var.name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = 1

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name   = "nginx"
    container_port   = 80
  }

  load_balancer {
    target_group_arn = "${var.hello_target_group_arn}"
    container_name   = "hello"
    container_port   = 81
  }

  load_balancer {
    target_group_arn = "${var.text_target_group_arn}"
    container_name   = "text"
    container_port   = 82
  }
}