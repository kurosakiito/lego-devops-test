resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  count = "${length(split(",", var.az))}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index + 0)}"
  map_public_ip_on_launch = "true" 
  availability_zone       = "${element(split (",", var.az), count.index)}"
  tags = {
     Name = "${var.name}-public-subnet"
 }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public" {
  route_table_id = "${aws_route_table.public.id}"
  gateway_id = "${aws_internet_gateway.igw.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.az))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}