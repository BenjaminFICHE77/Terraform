resource "aws_route53_zone" "principal" {
  name         = "benjaminfiche-fastapi.fr" # Remplacez par votre domaine (attention au point final)
}

resource "aws_route53domains_domain" "domain" {
  domain_name       = "benjaminfiche-fastapi.fr"
  duration_in_years = 1
  auto_renew        = true

  # On lie directement le domaine aux serveurs de noms (NS) générés par notre zone hébergée ci-dessus
#   dynamic "name_server" {
#     for_each = aws_route53_zone.principal.name_servers
#     content {
#       name = name_server.value
#     }
#   }

  # Coordonnées du propriétaire (Obligatoire)
  registrant_contact {
    contact_type      = "PERSON"
    first_name        = "Benjamin"
    last_name         = "Fiche"
    email             = "benjamin.f@datascientest.com"
    phone_number      = "+33.612345678" # Attention au format +CC.Numero
    address_line_1    = "123 Rue de la Paix"
    city              = "Paris"
    zip_code          = "75001"
    country_code      = "FR"
  }

  # Coordonnées de l'administrateur (Obligatoire)
  admin_contact {
    contact_type      = "PERSON"
    first_name        = "Benjamin"
    last_name         = "Fiche"
    email             = "benjamin.f@datascientest.com"
    phone_number      = "+33.612345678"
    address_line_1    = "123 Rue de la Paix"
    city              = "Paris"
    zip_code          = "75001"
    country_code      = "FR"
  }

  # Coordonnées du contact technique (Obligatoire)
  tech_contact {
    contact_type      = "PERSON"
    first_name        = "Benjamin"
    last_name         = "Fiche"
    email             = "benjamin.f@datascientest.com"
    phone_number      = "+33.612345678"
    address_line_1    = "123 Rue de la Paix"
    city              = "Paris"
    zip_code          = "75001"
    country_code      = "FR"
  }

  # Optionnel : Masquer vos données personnelles sur le WHOIS public
  registrant_privacy = true
  admin_privacy      = true
  tech_privacy       = true
}

resource "aws_route53_record" "app_dns" {
  zone_id = aws_route53_zone.principal.zone_id
  name    = "www.benjaminfiche-fastapi.fr" # Le sous-domaine souhaité
  type    = "A"                      # Route 53 utilise le type "A" pour les Alias ALB

  alias {
    name                   = aws_lb.benjaminfiche.dns_name # Le nom DNS généré par votre ALB
    zone_id                = aws_lb.benjaminfiche.zone_id  # Le Zone ID de l'ALB (requis pour l'Alias)
    evaluate_target_health = true                    # Permet à Route 53 de vérifier la santé de l'ALB
  }
}

resource "aws_route53_record" "validation_acm" {
  for_each = {
    for dvo in aws_acm_certificate.certificat.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.principal.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.certificat.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_acm : record.fqdn]
}