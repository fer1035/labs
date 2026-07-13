module "example" {
  source = "../../"

  application_name             = "aws_network"
  vpc_cidr                     = "10.0.0.0/24"
  subnet_public_1_cidr         = "10.0.0.128/26"
  subnet_public_2_cidr         = "10.0.0.192/26"
  subnet_public_1_az           = "us-east-1a"
  subnet_public_2_az           = "us-east-1b"
  nat_availability_mode        = "regional"
  enable_internet_connectivity = true

  subnets_private = {
    subnet_private_1 = {
      cidr = "10.0.0.0/26"
      az   = "us-east-1a"
    }
    subnet_private_2 = {
      cidr = "10.0.0.64/26"
      az   = "us-east-1b"
    }
  }
}

output "network" {
  value = module.network
}
