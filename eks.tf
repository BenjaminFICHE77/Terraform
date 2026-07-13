module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "benjaminfiche-eks-cluster"
  cluster_version = "1.30" # Version stable de Kubernetes

  # Autorise l'accès public au endpoint du cluster pour vos commandes kubectl
  cluster_endpoint_public_access  = true

  # On réutilise vos réseaux existants (Private Subnets obligatoires pour les Nodes)
  vpc_id     = aws_vpc.benjaminfiche-vpc.id
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  # Configuration des instances qui vont héberger vos Pods (Node Group)
  eks_managed_node_groups = {
    wordpress_nodes = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t3.medium"] # WordPress + Kubernetes demande un peu plus de RAM (4Go minimum recommandé)
      capacity_type  = "ON_DEMAND"
    }
  }
}