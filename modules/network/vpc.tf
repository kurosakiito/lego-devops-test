resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  tags = {
    Name = "${var.name}"
 }
}

resource "aws_security_group" "sg" {
  vpc_id	 = "${aws_vpc.vpc.id}"
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["${var.cidr_block}"]
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  
   tags = {
    Name = "${var.name}"
 }
}