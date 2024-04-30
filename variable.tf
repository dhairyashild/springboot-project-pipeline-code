variable "vpc_cidr" {
  type = string
}

#jenkins vpc variables
variable "public_subnets" {
  type = list(string)
}

#jenkins ec2 variables
variable "instance_type" {
  type    = string
  default = "t2.micro"

}
#worker ec2 variable

variable "instance_type_sonar"{
  type = string
  default = "t2.medium"
}


#jenkins sg variable
variable "sg-tag" {
  type = string
  default = "jenkins+sg"
}
variable "sgname" {
  type = string
  default = "jenkins+sg"
}
variable "vpc_id" {
  type = string
  default = "192.168.0.0/16"
}
variable "port_sonar" {
  type    = list(number)
  default = [443,80,8080,9000,22] # Example values, adjust as needed.
}

#sonar-sg
variable "sg-tag_sonar" {
  type = string
  default = "sonar_sg_1"
}
variable "sgname_sonar" {
  type = string
  default = "sonar_sg"
}

variable "port_jenkins" {
  type    = list(number)
  default = [443,8080,80,22] # Example values, adjust as needed.
}
