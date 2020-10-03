output "security_group_id" {
	value = "${aws_security_group.sg.id}"
}

output "private_subnet_id" {
	value = "${aws_subnet.private.*.id}"
}

output "target_group_arn" {
	value = "${aws_lb_target_group.target_group.arn}"
}