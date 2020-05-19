
# AWS provider

provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
  version = "<= 1.24.0"
}
