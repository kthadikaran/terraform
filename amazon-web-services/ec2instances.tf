#========================EC2 Web Instances============================

locals {
  websubnet_ids = concat([aws_subnet.stopnshop-prod-websubnet-1a.id], [aws_subnet.stopnshop-prod-websubnet-1b.id])
}


resource "aws_instance" "stopnshop-webserver" {
  # Create one instance for each subnet
  count           = 2
  ami             = "ami-01581ffba3821cdf3"
  instance_type   = "t2.micro"
  key_name        = "demoinstance"
  subnet_id       = element(local.websubnet_ids, count.index)
  security_groups = [aws_security_group.stopnshop-webserver-sg.id]
  user_data       = <<-EOF
		#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF

  tags = {
    Name        = "stopnshop-webserver${count.index}"
    Environment = "production"
    Project     = "stopnshop"
    Owner       = "kthadikaran@gmail.com"
  }
}
