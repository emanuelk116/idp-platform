terraform {
  backend "s3" {}
}

data "aws_iam_user" "terraform_user" {
  user_name = "terraform-user"
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.terraform_user.arn]
    }
  }
}

data "aws_iam_policy_document" "eks_admin_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_user.terraform_user.arn]
    }
  }
}

resource "aws_iam_role" "eks_admin_role" {
  name               = "${var.name_prefix}-eks-admin-role"
  assume_role_policy = data.aws_iam_policy_document.eks_admin_assume_role.json
  tags = {
    Name = "${var.name_prefix}-eks-admin-role"
  }
}

resource "aws_iam_role_policy" "eks_admin_permissions" {
  name = "eks-admin-permissions"
  role = aws_iam_role.eks_admin_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:AccessKubernetesApi"
        ],
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.name_prefix}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  tags = {
    Name = "${var.name_prefix}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Node group IAM role
data "aws_iam_policy_document" "eks_nodes_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_nodes_role" {
  name               = "${var.name_prefix}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_assume_role.json
  tags = {
    Name = "${var.name_prefix}-eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])
  role       = aws_iam_role.eks_nodes_role.name
  policy_arn = each.value
}
