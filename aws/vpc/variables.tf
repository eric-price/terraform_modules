variable "private_eks_subnets" {
  type = map(string)
}
variable "env" {
  type = string
}
variable "private_subnets" {
  type = map(string)
}
variable "public_subnets" {
  type = map(string)
}
variable "region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
