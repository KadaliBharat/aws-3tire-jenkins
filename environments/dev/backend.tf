terraform {
  backend "s3" {
    # REPLACE WITH YOUR ACTUAL BUCKET NAME
    bucket         = "my-devsecops-tfstate-bucket-12345" 
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    
    # The DynamoDB table name
    dynamodb_table = "devsecops-terraform-locks"
    encrypt        = true
  }
}
