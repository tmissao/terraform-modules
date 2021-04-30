output "arn" {
  description = "ARN for the created Amazon DocumentDB"
  value =  "${aws_docdb_cluster.docdb.arn}"
}

output "endpoint" {
  description = "Endpoint for the created Amazon DocumentDB"
  value =  "${aws_docdb_cluster.docdb.endpoint}"
}

output "ssm_endpoint" {
  description = "SSM Key for Cluster's Endpoint"
  value = "${module.SsmClusterEndPoint.parameter_name}"
}

output "reader_endpoint" {
  description = "Reader Endpoint for the created Amazon DocumentDB"
  value =  "${aws_docdb_cluster.docdb.reader_endpoint}"
}

output "ssm_reader_endpoint" {
  description = "SSM Key for Cluster's Reader Endpoint"
  value = "${module.SsmClusterReaderEndPoint.parameter_name}"
}

output "port" {
  description = "Port for the created Amazon DocumentDB"
  value =  "${var.docdb_port}"
}

output "ssm_port" {
  description = "SSM Key for Cluster's Port"
  value = "${module.SsmClusterPort.parameter_name}"
}

output "username" {
  description = "Username for the created Amazon DocumentDB"
  value =  "${var.docdb_username}"
}

output "ssm_username" {
  description = "SSM Key for Cluster's Username"
  value = "${module.SsmClusterUsername.parameter_name}"
}

output "password" {
  description = "Password for the User created Amazon DocumentDB"
  value =  "${var.docdb_password}"
}

output "ssm_password" {
  description = "SSM Key for Cluster's Password"
  value = "${module.SsmClusterPassword.parameter_name}"
}

output "sg_client_id" {
  description = "ID for the created Amazon Security Group"
  value =  aws_security_group.docdb_client.id
}

output "sg_client_name" {
  description = "ID for the created Amazon Security Group"
  value =  aws_security_group.docdb_client.name
}

output "ssm_sg_client" {
  description = "SSM Key Security Group Client"
  value =  module.SsmClusterSgClient.parameter_name
}

output "sg_docdb_id" {
  description = "ID for the created Amazon Security Group"
  value =  aws_security_group.docdb.id
}

output "sg_docdb_name" {
  description = "ID for the created Amazon Security Group"
  value =  aws_security_group.docdb.name
}
