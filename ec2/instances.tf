//Declaring Variables
variable "wp_ami" {}
variable "mysql_ami" {}
variable "inst_type" {}
variable "pub_sn_id" {}
variable "pri_sn_id" {}

//Launching WordPress Instance
resource "aws_instance" "wp" {
  ami             = "${var.wp_ami}"
  instance_type   = "${var.inst_type}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.wp_sg.id}"]
  subnet_id       = "${var.pub_sn_id}"

  //Labelling the Instance
  tags = {
    Name = "WordPress"
    env  = "Production"
  }

  depends_on = [
    aws_instance.mysql,
    aws_security_group.wp_sg
  ]
}

//Launching MySQL Instance
resource "aws_instance" "mysql" {
  ami             = "${var.mysql_ami}"
  instance_type   = "${var.inst_type}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.mysql_sg.id}"]
  subnet_id       = "${var.pri_sn_id}"

  //Labelling the Instance
  tags = {
    Name = "MySQL"
    env  = "Production"
  }

  depends_on = [
    aws_security_group.mysql_sg,
    aws_key_pair.generated_key
  ]
}


//Launching Bastion Host Instance
resource "aws_instance" "bastion" {
  ami             = "ami-08f3d892de259504d"
  instance_type   = "${var.inst_type}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  subnet_id       = "${var.pub_sn_id}"

  //Copy our Database Instance Key into Bastion Host
  provisioner "file" {
    connection {
      agent       = false
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${tls_private_key.tls_key.private_key_pem}"
      host        = "${aws_instance.bastion.public_ip}"
    }

    source      = "wp-env-key.pem"
    destination = "/home/ec2-user/wp-env-key.pem" 
  }

  //Labelling the Instance
  tags = {
    Name = "Bastion"
    env  = "Management"
  }

  depends_on = [
    aws_security_group.bastion_sg,
    aws_key_pair.generated_key
  ]
}

//Database Host Private DNS
output "db_host" {
  value = "${aws_instance.mysql.private_dns}"
}

//Database Host Private IP
output "db_host_ip" {
  value = "${aws_instance.mysql.private_ip}"
}

//WordPress Host Public DNS
output "wp_dns" {
  value = "${aws_instance.wp.public_dns}"
}

//Bastion Host IP
output "bastion_host" {
  value = "${aws_instance.bastion.public_ip}"
}
