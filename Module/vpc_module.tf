module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  #VPC Details

  name            = "oso-dev"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  #DataBase_Subnet
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  #   create_database_nat_gateway_route = true
  #   create_database_internet_gateway_route = true 
  database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]
  #NAT for outbound communication 
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "public-subnets"
  }

  private_subnet_tags = {
    Name = "private-subnets"
  }

  database_subnet_tags = {
    Name = "database-subnets"
  }

  tags = {
    Owner      = "Osondu"
    Environmet = "Dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }

}
