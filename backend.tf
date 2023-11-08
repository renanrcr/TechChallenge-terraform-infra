terraform {
 backend "s3" {
   bucket = "techchallenge-terraform-state"
   key = "terraform.tfstate"
   region = "us-east-1"
   encrypt = true
   dynamodb_table = "terraform-lock"
 } 
}