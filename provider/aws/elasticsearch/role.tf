resource "aws_iam_service_linked_role" "elasticsearch_service_linked_role" {
    count = var.create_linked_role ? 1 : 0
    aws_service_name = "es.amazonaws.com"
    description      = "Allows Amazon ES to manage AWS resources for a domain on your behalf."
}