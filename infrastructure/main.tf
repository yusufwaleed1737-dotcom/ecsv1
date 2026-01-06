
module "network" {
    source = "./modules/network"

    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name

    publicsubnet1_az = var.publicsubnet1_az
    publicsubnet2_az = var.publicsubnet2_az

    privatesubnet1_az = var.privatesubnet1_az
    privatesubnet2_az = var.privatesubnet2_az

    public1_cidr = var.public1_cidr
    public2_cidr = var.public2_cidr

    private1_cidr = var.private1_cidr
    private2_cidr = var.private2_cidr   
}


module "security" {
    source = "./modules/security"
    vpc_id = module.network.vpc_id
}


module "acm" {
    source = "./modules/acm"

    domain_name = var.domain_name
    deployment_id = var.deployment_id
}

module "s3" {
    source = "./modules/s3"
    deployment_id = var.deployment_id
}

module "alb" {
    source = "./modules/alb"

    app_domain = var.app_domain
    alb_security_group_id = [module.security.alb_security_group_id]
    publicsubnet_ids = module.network.publicsubnet_ids
    logs_bucket_name = module.s3.logs_bucket_name
    vpc_id = module.network.vpc_id
    aws_certificate_arn = module.acm.aws_certificate_arn
    route_53_zone_id = module.acm.route_53_zone_id
    deployment_id = var.deployment_id
}


module "ecs" {
    source = "./modules/ecs"

    ecs_cluster_name = var.ecs_cluster_name
    ecs_task_cpu = var.ecs_task_cpu
    ecs_task_memory = var.ecs_task_memory
    ecr_repository_url = var.ecr_repository_url
    aws_region = var.aws_region
    privatesubnet_ids = module.network.privatesubnet_ids
    tasks_security_group_id = module.security.tasks_security_group_id
    alb_tg_arn = module.alb.alb_tg_arn
    https_listener_arn = module.alb.https_listener_arn
    deployment_id = var.deployment_id
}