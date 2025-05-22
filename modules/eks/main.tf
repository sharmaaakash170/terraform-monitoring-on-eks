resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = var.eks_role_arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-eks-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types

  depends_on = [aws_eks_cluster.this]
}