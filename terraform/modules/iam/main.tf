resource "aws_iam_role" "this" {
  name = "Jenkins-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "this" {
  name = "Jenkins-instance-profile"
  role = aws_iam_role.this.name
}