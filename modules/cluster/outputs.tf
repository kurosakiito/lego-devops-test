output "cluster_id" {
  value = "${aws_ecs_cluster.cluster.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.cluster.name}"
}

output "task_role_arn" {
  value = "${aws_iam_role.iam.arn}"
}
