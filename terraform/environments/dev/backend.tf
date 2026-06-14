terraform {
  backend "s3" {
    bucket         = "book-review-terraform-state-pocky"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "book-review-terraform-locks"
    encrypt        = true
  }
}