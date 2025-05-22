module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
}

module "vpc" {
  source              = "../../modules/vpc"
  project_name        = var.project_name
  public_subnet_cidrs = var.public_subnet_cidrs
  vpc_cidr_block      = var.vpc_cidr_block
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                 = var.azs
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
}

module "eks" {
  source            = "../../modules/eks"
  project_name      = var.project_name
  eks_role_arn      = module.iam.eks_role_arn
  eks_node_role_arn = module.iam.eks_node_role_arn
  subnet_ids        = module.vpc.public_subnet_ids
  k8s_version       = var.k8s_version
  instance_types    = var.instance_types
  max_size          = var.max_size
  min_size          = var.min_size
  desired_size      = var.desired_size
  depends_on = [ module.iam, module.vpc ]
}