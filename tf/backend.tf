terraform {
  backend "s3" {
    bucket = "my-demo-terraform-backend"
    key = "hello-ec2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
    region = "us-east-1"
    # s3 backend does not support assuming a role with web identity - https://github.com/hashicorp/terraform/issues/31244
    shared_credentials_file = "~/.aws/credentials"
  }
}
