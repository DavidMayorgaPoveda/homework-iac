module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  owner              = var.owner
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  environment       = var.environment
  owner             = var.owner
  instance_type     = var.instance_type
  your_name         = var.your_name
  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.web_security_group_id
}
