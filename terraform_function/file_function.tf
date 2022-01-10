locals {
  remote_ip_list = split(",", file("./remote_ip_address.txt"))
}

output "rmeoteIP"{
  value = local.remote_ip_list
}

remote_ip_address.txt
192.168.86.129
192.168.86.132
192.168.86.136
192.168.86.138
