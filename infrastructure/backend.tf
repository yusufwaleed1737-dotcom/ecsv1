terraform {
  backend "s3" {
    bucket         = "terraform-state-threat-modelling"  # NEW bucket
    key            = "threat-modelling/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"  # For state locking
  }
}