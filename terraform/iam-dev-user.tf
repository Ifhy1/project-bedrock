# bedrock-dev-view IAM user
resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
}

# Console login profile
resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = false
}

# Attach ReadOnlyAccess policy
resource "aws_iam_user_policy_attachment" "dev_view_readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Access key for CLI/grader access
resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}