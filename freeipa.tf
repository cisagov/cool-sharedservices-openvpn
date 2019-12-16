#-------------------------------------------------------------------------------
# Configure the master and replica modules.
#-------------------------------------------------------------------------------
module "ipa_master" {
  source = "github.com/cisagov/freeipa-master-tf-module"

  providers = {
    aws            = aws
    aws.public_dns = aws.public_dns
  }

  admin_pw                    = var.ipa_admin_pw
  associate_public_ip_address = true
  cert_bucket_name            = var.cert_bucket_name
  cert_pw                     = var.ipa_master_cert_pw
  cert_read_role_arn          = module.certreadrole_ipa_master.arn
  directory_service_pw        = var.ipa_directory_service_pw
  domain                      = var.cool_domain
  hostname                    = "ipa.${var.cool_domain}"
  # TODO: At some point this should be a private subnet's reverse zone
  private_reverse_zone_id = aws_route53_zone.public_subnet_private_reverse_zones[0].zone_id
  private_zone_id         = aws_route53_zone.private_zone.zone_id
  public_zone_id          = data.aws_route53_zone.public_zone.zone_id
  realm                   = upper(var.cool_domain)
  # TODO: At some point this should be a private subnet
  subnet_id           = module.public_subnets.subnet_ids[0]
  tags                = var.tags
  trusted_cidr_blocks = var.trusted_cidr_blocks
}

module "ipa_replica1" {
  source = "github.com/cisagov/freeipa-replica-tf-module"

  providers = {
    aws            = aws
    aws.public_dns = aws.public_dns
  }

  admin_pw                    = var.ipa_admin_pw
  associate_public_ip_address = true
  cert_bucket_name            = var.cert_bucket_name
  cert_pw                     = var.ipa_replica1_cert_pw
  cert_read_role_arn          = module.certreadrole_ipa_replica1.arn
  hostname                    = "ipa-replica1.${var.cool_domain}"
  master_hostname             = "ipa.${var.cool_domain}"
  # TODO: At some point this should be a private subnet's reverse zone
  private_reverse_zone_id  = aws_route53_zone.public_subnet_private_reverse_zones[1].zone_id
  private_zone_id          = aws_route53_zone.private_zone.zone_id
  public_zone_id           = data.aws_route53_zone.public_zone.zone_id
  server_security_group_id = module.ipa_master.server_security_group_id
  # TODO: At some point this should be a private subnet
  subnet_id = module.public_subnets.subnet_ids[1]
  tags      = var.tags
}

module "ipa_replica2" {
  source = "github.com/cisagov/freeipa-replica-tf-module"

  providers = {
    aws            = aws
    aws.public_dns = aws.public_dns
  }

  admin_pw                    = var.ipa_admin_pw
  associate_public_ip_address = true
  cert_bucket_name            = var.cert_bucket_name
  cert_pw                     = var.ipa_replica2_cert_pw
  cert_read_role_arn          = module.certreadrole_ipa_replica2.arn
  hostname                    = "ipa-replica2.${var.cool_domain}"
  master_hostname             = "ipa.${var.cool_domain}"
  # TODO: At some point this should be a private subnet's reverse zone
  private_reverse_zone_id  = aws_route53_zone.public_subnet_private_reverse_zones[2].zone_id
  private_zone_id          = aws_route53_zone.private_zone.zone_id
  public_zone_id           = data.aws_route53_zone.public_zone.zone_id
  server_security_group_id = module.ipa_master.server_security_group_id
  # TODO: At some point this should be a private subnet
  subnet_id = module.public_subnets.subnet_ids[2]
  tags      = var.tags
}
