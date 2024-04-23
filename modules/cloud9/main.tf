resource "aws_iam_role" "cloud9_role" {
  name = "${var.instance_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_policy" "codecommit_access" {
  name   = "${var.instance_name}_CodeCommitAccess"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "codecommit:*"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codecommit_policy_attach" {
  role       = aws_iam_role.cloud9_role.name
  policy_arn = aws_iam_policy.codecommit_access.arn
}

resource "aws_cloud9_environment_ec2" "cloud9_env" {
  name            = var.instance_name
  instance_type   = var.instance_type
  image_id        = "ubuntu-22.04-x86_64"
}
