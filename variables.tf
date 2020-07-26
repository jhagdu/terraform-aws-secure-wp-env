//WordPress AMI ID Variable
variable "wordpress" {
  type    = string
  default = "ami-00a7bfe3527f0db19"
}

//MySQL AMI ID Variable
variable "mysql" {
  type    = string
  default = "ami-0b15787ed8a5a597a"
}

//Instance Type Variable
variable "inst_type" {
  type    = string
  default = "t2.micro"
}
