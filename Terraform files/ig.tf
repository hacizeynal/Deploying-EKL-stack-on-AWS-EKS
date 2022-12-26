resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.eks_cluster_vpc.id
  # We can have 1 Internet Gateway per VPC
  tags = {
    Name = "Internet Gateway"
  }
}
