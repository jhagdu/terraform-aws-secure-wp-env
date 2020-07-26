//Declaring variable
variable "vpc_id" {}

//Creating Key
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

//Generating Key-Value Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "wp-env-key"
  public_key = "${tls_private_key.tls_key.public_key_openssh}"

  depends_on = [
    tls_private_key.tls_key
  ]
}

//Saving Private Key PEM File
resource "local_file" "key-file" {
  content  = "${tls_private_key.tls_key.private_key_pem}"
  filename = "wp-env-key.pem"

  depends_on = [
    tls_private_key.tls_key
  ]
}

//Creating Security Group
resource "aws_security_group" "wp_sg" {
  name        = "wp-SG"
  description = "WordPress Security Group"
  vpc_id      = "${var.vpc_id}"

  //Adding Rules to Security Group 

  //SSH Rule
  ingress {
    description = "SSH Rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //HTTP Rule
  ingress {
    description = "HTTP Rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//Creating Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-SG"
  description = "WordPress Security Group"
  vpc_id      = "${var.vpc_id}"

  //Adding Rules to Security Group 

  //SSH Rule
  ingress {
    description = "SSH Rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//Creating Security Group
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-SG"
  description = "MySQL Security Group"
  vpc_id      = "${var.vpc_id}"

  //Adding Rules to Security Group 

  //SSH Rule
  ingress {
    description = "SSH Rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  //HTTP Rule
  ingress {
    description = "HTTP Rule"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wp_sg.id]
  }

  //Allow All Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_security_group.bastion_sg,
    aws_security_group.wp_sg
  ]
}
