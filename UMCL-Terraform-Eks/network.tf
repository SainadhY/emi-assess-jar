locals {
  az_length   = "${length(slice(local.az_names, 0, 2))}"
  pri_sub_ids = "${aws_subnet.private.*.id}"
  az_names    = "${data.aws_availability_zones.azs.names}"
  pub_sub_ids = "${aws_subnet.public.*.id}"
}

resource "aws_vpc" "my_app" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = "${
    map(
    "Name", "JavahomeVpc",
    "kubernetes.io/cluster/${var.eks_cluster}", "shared",
    "Environment", "${terraform.workspace}"
    )
  }"
}

resource "aws_subnet" "public" {
  count                   = "${length(slice(local.az_names, 0, 2))}"
  vpc_id                  = "${aws_vpc.my_app.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  availability_zone       = "${local.az_names[count.index]}"
  map_public_ip_on_launch = true

  tags = "${
    map(
     "Name", "PublicSubnet-${count.index + 1}",
     "kubernetes.io/cluster/${var.eks_cluster}", "shared",
    )
  }"
}

resource "aws_subnet" "private" {
  #count             = "${length(slice(local.az_names, 0, 2))}"
  count             = "${local.az_length}"
  vpc_id            = "${aws_vpc.my_app.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 8, count.index + local.az_length)}"
  availability_zone = "${local.az_names[count.index]}"

  tags = "${
    map(
     "Name", "PrivateSubnet-${count.index + 1}",
     "kubernetes.io/cluster/${var.eks_cluster}", "shared",
    )
  }"
}

resource "aws_route_table" "privatert" {
  vpc_id = "${aws_vpc.my_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw.id}"

    #instance_id = "${aws_instance.nat.id}"
  }

  tags = {
    Name = "PrivateRT"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = "${aws_vpc.my_app.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route_table_association" "pub_sub_association" {
  count          = "${length(slice(local.az_names, 0, 2))}"
  subnet_id      = "${local.pub_sub_ids[count.index]}"
  route_table_id = "${aws_route_table.publicrt.id}"
}

resource "aws_route_table_association" "private_sub_association" {
  count          = "${length(slice(local.az_names, 0, 2))}"
  subnet_id      = "${local.pri_sub_ids[count.index]}"
  route_table_id = "${aws_route_table.privatert.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.my_app.id}"

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  #instance                  = "${aws_instance.nat.id}"
  #associate_with_private_ip = "${aws_instance.nat.private_ip}"
  #depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${local.pub_sub_ids[0]}"
  depends_on    = ["aws_eip.nat"]

  tags = {
    Name = "NAT Gateway"
  }
}

/*resource "aws_key_pair" "deployer" {
  key_name   = "jenkins_pub_key"
  public_key = "${var.jenkins_pub_key_pair}"
}*/

