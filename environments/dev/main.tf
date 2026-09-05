# Call the VPC Module
module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  # Deploy across 2 Availability Zones
  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]
}

# Phase 3, 4, 5: Security Groups
module "security_groups" {
  source      = "../../modules/security-groups"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

# Phase 3: IAM
module "iam" {
  source      = "../../modules/iam"
  environment = var.environment
}

# Phase 3: Public ALB
module "public_alb" {
  source            = "../../modules/public-alb"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  nlb_sg_id         = module.security_groups.public_nlb_sg_id
}

# Phase 3: Web ASG
module "web_asg" {
  source                    = "../../modules/web-asg"
  environment               = var.environment
  public_subnet_ids         = module.vpc.public_subnet_ids
  web_sg_id                 = module.security_groups.web_sg_id
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
  target_group_arn          = module.public_alb.target_group_arn
}

# Phase 4: Private ALB
module "private_alb" {
  source             = "../../modules/private-alb"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  private_nlb_sg_id  = module.security_groups.private_nlb_sg_id
}

# Phase 4: App ASG
module "app_asg" {
  source                    = "../../modules/app-asg"
  environment               = var.environment
  private_subnet_ids        = module.vpc.private_subnet_ids
  app_sg_id                 = module.security_groups.app_sg_id
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
  target_group_arn          = module.private_alb.target_group_arn
}

# Phase 5: Primary Database
module "rds_primary" {
  source        = "../../modules/rds-primary"
  environment   = var.environment
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg_id      = module.security_groups.db_sg_id
  db_username   = var.db_username
  db_password   = var.db_password
}

# Phase 6: Backup
module "backup" {
  source      = "../../modules/backup"
  environment = var.environment
}

# Phase 6: CloudWatch Alarms
module "cloudwatch" {
  source       = "../../modules/cloudwatch"
  environment  = var.environment
  web_asg_name = module.web_asg.asg_name
  app_asg_name = module.app_asg.asg_name
}
