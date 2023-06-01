#output "database" {
 # value = aws_db_instance.database.address
#}

#output "backend_bucket_name" {
#  value = aws_s3_bucket.backend.id
#}

#output "public_ip" {
#  description = "Contains the public IP address"
#  value       = aws_eip.backend.public_ip
#}

output "dev_be_lb_address" {
  value = aws_lb.backend.dns_name
}


# output "ecs_cluster" {
#   value = aws_ecs_cluster.backend
# }

# output "ecs_service" {
#   value = aws_ecs_service.demo
# }
