resource "cloudflare_record" "argocd" {
  zone_id         = "<zone_id>"
  name            = "argorollouts.sandbox"
  value           = var.loadbalancer_dns
  type            = "CNAME"
  ttl             = 3600
  allow_overwrite = true
}
