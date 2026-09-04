# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
      configuration_aliases = [aws.dr]
    }
  }
}

resource "aws_db_instance" "replica" {
  provider               = aws.dr
  identifier             = "${var.environment}-replica-db"
  replicate_source_db    = var.primary_db_arn
  instance_class         = "db.t3.micro"
  skip_final_snapshot    = true

  # As per standard training setup, cross-region replica goes into default VPC 
  # of the DR region unless a peered VPC is provided. 
}
