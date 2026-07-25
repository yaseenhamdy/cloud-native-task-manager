
resource "aws_iam_policy" "argo-cd-policy" {

  name = "argo-cd-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [
          "eks:DescribeCluster",
          "sts:GetCallerIdentity"
        ]

        Resource = "*"
      }
    ]
  })
}
