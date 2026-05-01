module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}

module "ec2" {
  source                = "./modules/ec2"
  subnet_id             = module.vpc.subnet_id
  security_group_id     = module.vpc.security_group_id
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name
  instance_name         = var.instance_name
}