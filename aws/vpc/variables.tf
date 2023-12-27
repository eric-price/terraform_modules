variable "private_eks_subnets" {
  type = map(any)
}
variable "env" {
  type = string
}
variable "private_subnets" {
  type = map(any)
}
variable "public_subnets" {
  type = map(any)
}
variable "region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
