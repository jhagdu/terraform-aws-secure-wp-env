//Creating Internet Gateway
resource "aws_internet_gateway" "int_gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags = {
    Name = "Internet GW"
  }

  depends_on = [
    aws_subnet.public_subnet
  ]
}

//Creating Route Table for Internet GW
resource "aws_route_table" "route_table_ig" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.int_gw.id}"
  }

  tags = {
    Name = "IGW Route Table"
  }

  depends_on = [
    aws_internet_gateway.int_gw
  ]
}

//Creating and EIP
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "EIP"
  }
}

//Creating NAT Gaetway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [
    aws_subnet.public_subnet,
    aws_subnet.private_subnet
  ]
}

//Creating Route Table for NAT GW
resource "aws_route_table" "route_table_ngw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags = {
    Name = "NAT GW Route Table"
  }

  depends_on = [
    aws_nat_gateway.nat_gw
  ]
}

//Associate Route Table with Public Subnet for IG
resource "aws_route_table_association" "rt_to_ig" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.route_table_ig.id}"

  depends_on = [
    aws_route_table.route_table_ig
  ]
}

//Associate Route Table with Private Subnet for NGW
resource "aws_route_table_association" "rt_to_ngw" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.route_table_ngw.id}"

  depends_on = [
    aws_route_table.route_table_ngw
  ]
}
