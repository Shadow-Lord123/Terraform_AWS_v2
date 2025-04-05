
resource "aws_route53_zone" "primary" {
  name = "kritagya-33.co.uk"
}

resource "aws_route53_record" "www-dev" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.kritagya-33.co.uk"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "dev"
  records        = ["dev.kritagya-33.co.uk"]
}

resource "aws_route53_record" "www-live" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.kritagya-33.co.uk"
  type    = "CNAME"
  ttl     = 5

  weighted_routing_policy {
    weight = 90
  }

  set_identifier = "live"
  records        = ["live.kritagya-33.co.uk"]
}
