data "aws_route53_zone" "main" {    
  name         = "ntshalaempire.com"
  private_zone = false
}



resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.ntshalaempire.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}


resource "aws_acm_certificate" "app-cert" {
  domain_name = "app.ntshalaempire.com"
  validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "app_valisation" {
    for_each ={ 
        for dvo in aws_acm_certificate.app-cert.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            type   = dvo.resource_record_type
            record = dvo.resource_record_value
        }
    }
    name = each.value.name
    type = each.value.type
    zone_id = data.aws_route53_zone.main.zone_id
    records = [each.value.record]
    ttl = 60
}

resource "aws_acm_certificate_validation" "app-cert-validation" {
    certificate_arn = aws_acm_certificate.app-cert.arn
    validation_record_fqdns = [for record in aws_route53_record.app_valisation : record.fqdn]
}