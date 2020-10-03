resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id = "${aws_subnet.public.0.id}"

  tags = {
    Name = "${var.name}-ngw"
  }
}

resource "aws_subnet" "private" {
 count = "${length(split(",", var.az))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, 8, count.index + length(split(",", var.az)) + 0)}"
  availability_zone       = "${element(split (",", var.az), count.index)}"
  tags = {
     Name = "${var.name}-private-subnet"
 }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "private" {
  route_table_id = "${aws_route_table.private.id}"
  nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count = "${length(split(",", var.az))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}