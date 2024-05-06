terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-2"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

# INSTANCE STACK

resource "aws_db_instance" "ug_dbs" {
  db_name = "UgoDatabase"
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "password"
  vpc_security_group_ids = [aws_security_group.ugsg.id]
  db_subnet_group_name = aws_db_subnet_group.ug_subnet_group.name
  backup_retention_period = 1 # Number of days to retain automated backups
  backup_window = "03:00-04:00" # Preferred UTC backup window (hh24:mi-hh24:mi format)
  maintenance_window = "mon:04:00-mon:04:30" # Preferred UTC maintenance window
  kms_key_id = aws_kms_key.ug_kms_key.arn  # Specify the KMS key ID for encryption (replace with your own KMS key ARN)
  storage_encrypted    = true #To enable kms you must enable Storage Encrypted when specifying kms id. 
  skip_final_snapshot = true  #required to destroy
 # final_snapshot_identifier = "ug-snap"
}

# INCREASING THE SECURITY POSTURE OF RDS
resource "aws_kms_key" "ug_kms_key" {
  description = "My KMS Key for RDS Encryption"
  deletion_window_in_days = 30

  tags = {
    Name = "UgKMSKey"
  }
}

# NETWORK STACK
resource "aws_vpc" "ug_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "ugsub1" {
  vpc_id     = aws_vpc.ug_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "ugsub2" {
  vpc_id     = aws_vpc.ug_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"
}

resource "aws_security_group" "ugsg" {
  name_prefix = "rds-"
  vpc_id = aws_vpc.ug_vpc.id

  # Add any additional ingress/egress rules as needed
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "ug_subnet_group" {     #Here we created the subnet group to attach all subnets for our instance stack utilization
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.ugsub1.id, aws_subnet.ugsub2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

# BACKUP & MAINTENANCE STACK

