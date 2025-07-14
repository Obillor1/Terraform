module "public_bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"
  name        = "${local.name}-public_bastion_sg"
  description = "Security group for SSH Port open for IPv4 CIDR, egress Port is open for everyone"
  vpc_id      = module.vpc.vpc_id

#Ingress Rules
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

#Egress Rules & CIDR ALL-ALL Open
    egress_rules = ["all-all"] #This is in the inputs attribute of the terraform module
    tags = local.common_tags
}
