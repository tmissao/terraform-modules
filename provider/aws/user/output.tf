output "name" {
  value = "${aws_iam_user.user.name}"
}

output "arn" {
  value = "${aws_iam_user.user.arn}"
}

output "access_key" {
  value = "${aws_iam_access_key.user_access_key.id}"
}

output "secret_key" {
  value = "${aws_iam_access_key.user_access_key.secret}"
}