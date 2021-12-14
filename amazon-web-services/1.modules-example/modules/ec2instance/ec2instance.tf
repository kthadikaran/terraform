resource "aws_instance" "ec2instance" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = var.instancetype
  
}
