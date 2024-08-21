# Data Source

# For example, you can use a data block to retrieve a list of Amazon Machine Images (AMIs) from AWS, and then use that data to select the appropriate AMI 
# for a virtual machine you are provisioning:

data "aws_ami" "example" {
  most_recent = true
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
 
resource "aws_instance" "example" {
  ami           = data.aws_ami.example.id
  instance_type = "t2.micro"
}
