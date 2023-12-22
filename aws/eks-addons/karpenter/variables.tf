variable "cluster_name" {
  type = string
}
variable "cluster_endpoint" {
  type = string
}
variable "env" {
  type = string
}
variable "region" {
  type = string
}
variable "irsa_oidc_provider_arn" {
  type = string
}
variable "eks_node_role_arn" {
  type = string
}
variable "karpenter_version" {
  type = string
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
