resource "aws_s3_bucket" "lambda_auth" {
 bucket = "techchallenge-terraform-s3-auth"
  tags = {
   Name = "${var.environment}-techchallenge-lambda-s3"
   Name = "${var.environment}-techchallenge-lambda-s3-auth"
  }
}