locals {
  remote_ip_list = split(",", file("./remote_ip_address.txt"))
}

output "rmeoteIP"{
  value = local.remote_ip_list
}

remote_ip_address.txt
192.168.86.0/23, 192.168.34.0/23, 192.168.36.0/24, 192.168.117/24
