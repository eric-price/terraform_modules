resource "cloudflare_record" "argocd" {
  zone_id         = "<zone_id>"
  name            = "argocd.sandbox"
  value           = var.loadbalancer_dns
  type            = "CNAME"
  ttl             = 3600
  allow_overwrite = true
}
