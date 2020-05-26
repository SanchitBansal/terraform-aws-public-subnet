
# Resource to create public subnet

resource "aws_subnet" "public" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count             = "${length(var.public_subnets)}"

  tags = "${merge(
    map("Name", "${format("%s-%s-public-%s", var.environment, var.name, element(split("-", element(var.availability_zones, count.index)),2))}"),
    map("role", "${var.name}"),
    map("az", "${element(var.availability_zones, count.index)}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

# Resource to create internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.public_subnets) >= 1 ? 1 : 0}"

  tags = "${merge(
    map("Name", "${format("%s-igw", var.environment)}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

#Resource to create route tables

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  count  = "${length(var.public_subnets)}"

  tags = "${merge(
    map("Name", "${format("%s-%s-rt-public-%s", var.environment, var.name, element(split("-", element(var.availability_zones, count.index)),2))}"),
    map("role", "${var.name}"),
    map("az", "${element(var.availability_zones, count.index)}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

# Resource to assosiate route tables to subnets

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.*.id[count.index]}"
  count          = "${length(var.public_subnets)}"
}

# Resource to create a routing table entry (a route) for internet gateway

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  count                  = "${length(var.public_subnets)}"
}

# Resource to create Nat Gateways

resource "aws_eip" "nateip" {
  vpc   = true
  count = "${length(var.availability_zones)}"

  tags = "${merge(
    map("Name", "${format("%s-eip-%s", var.environment, var.name)}"),
    map("role", "${var.name}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nateip.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
  count         = "${length(var.public_subnets)}"

  tags = "${merge(
    map("Name", "${format("%s-nat-%s", var.environment, var.name)}"),
    map("role", "${var.name}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}

# Resource to create NACL

resource "aws_network_acl" "public" {
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress     = "${var.public_network_acl_egress}"
  ingress    = "${var.public_network_acl_ingress}"

  tags = "${merge(
    map("Name", "${format("%s-acl-%s", var.environment, var.name)}"),
    map("role", "${var.name}"),
    map("environment", "${var.environment}"),
    var.custom_tags)
  }"
}
