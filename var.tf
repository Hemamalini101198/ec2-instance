variable "region" {
  description = "region where EC2 instance will be creted"
  type = string  
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type = string
}

variable "ami_id" {
  description = "ami id for the instance"
  type = string  
}

variable "instance_type" {
  description = "instance type of instance"
  type = string  
}

variable "key_name" {
 type = string
}

variable "s3_bucket"{
  description = "used to store pem key generated"
  type = string
}
