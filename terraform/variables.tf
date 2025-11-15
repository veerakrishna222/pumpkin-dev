variable "region" { default = "ap-south-1" }

variable "ami" {
  description = "Ubuntu 24.04 AMI"
  default = "ami-02b8269d5e85954ef"
}

variable "instance_type" { default = "t3.micro" }
variable "key_name"      { default = "pumkin" }

variable "bucket_name" {
  default = "my-ci-cd-demo-bucket-2025"
}

