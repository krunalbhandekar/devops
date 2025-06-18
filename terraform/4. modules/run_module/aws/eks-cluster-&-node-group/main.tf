module "eks_cluster" {
  source = "../../../modules/aws/eks-cluster-&-node-group"

  aws_region      = "ap-south-1"
  cluster_name    = "my-eks-cluster"
  subnet_ids      = ["subnet-0b575e3ed81f40f0f", "subnet-0c0fbbdfe05d03946", "subnet-017210b3677394759"]
  node_group_name = "my-node-group"
  desired_size    = 2
  max_size        = 3
  min_size        = 1
  instance_types  = ["t3.medium"]
}

output "print_cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "print_cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "print_cluster_arn" {
  value = module.eks_cluster.cluster_arn
}
