variable "addons" {}
variable "cert_domains" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "core_node_count" {
  type = number
}
variable "core_node_type" {
  type        = string
}
variable "core_node_volume_size" {
  type = number
}
variable "env" {
  type        = string
}
variable "fargate" {
  type        = bool
}
variable "log_types" {
  type = list(string)
}
variable "region" {
  type        = string
}
variable "worker_node_types" {
  type = list(string)
}
variable "worker_node_capacity_types" {
  type = list(string)
}
variable "worker_node_arch" {
  type = list(string)
}
variable "loadbalancer_cert" {
  type        = string
}
