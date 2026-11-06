output "instance_id" {
  description = "ID of the web server instance"
  value       = module.compute.instance_id
}

output "public_ip" {
  description = "Public IPv4 address of the web server"
  value       = module.compute.public_ip
}

output "website_url" {
  description = "URL of the deployed web page"
  value       = "http://${module.compute.public_ip}"
}
