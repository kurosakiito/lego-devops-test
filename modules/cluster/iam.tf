resource "aws_iam_role" "iam" {
  name = "${var.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = "${aws_iam_role.iam.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "container_instance" {
  name = "${aws_iam_role.iam.name}"
  role = "${aws_iam_role.iam.name}"
}