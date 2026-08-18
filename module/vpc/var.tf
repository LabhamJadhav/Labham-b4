variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "project" {
  default = "ITA"
}

variable "env" {
  default = "staging"
}

variable "pri_cidr" {
  default = "10.0.0.0/18"
}

variable "pub_cidr" {
  default = "10.0.16.0/20"
}
