//Creating VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "My-VPC"
  }
}

//Creating Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "172.31.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

//Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "172.31.16.0/24"

  tags = {
    Name = "private-subnet"
  }
}

//Outputs

output "vpc_id" {
    value = "${aws_vpc.my_vpc.id}"
}

output "pub_sn_id" {
    value = "${aws_subnet.public_subnet.id}"
}

output "pri_sn_id" {
    value = "${aws_subnet.private_subnet.id}"
}
