# A script which 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  profile = "default"
}
# Bring the VPC module
module "VpcModule" {
  source = "./VpcModule"
  aws_internet_gateway = module.gateway.aws_internet_gateway
 
}
# Use the Getaway module
module "gateway" {
  source = "./gateway"
  vpc_id = module.VpcModule.vpc_id
  aws_public = module.VpcModule.aws_public.id
  aws_private = module.VpcModule.aws_private.id

}
# Bring the Securirty Group module
module "Security_Group_Creation" {
    source = "./SecGroupModule"
    vpc_id = module.VpcModule.vpc_id

}

# Bring the ec2 Instance module
module "InstanceCreation" {
  source = "./InstanceCreationModule"
  aws_public = module.VpcModule.aws_public.id
  aws_private = module.VpcModule.aws_private.id
  security_group_id = module.Security_Group_Creation.security_group_id
}


