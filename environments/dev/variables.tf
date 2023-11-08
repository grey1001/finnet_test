variable "bucket_auth" {
  type = string
  default = "bucket1-dev1106"
}

variable "bucket_tags" {
  type = map(string)
  default = {
    "Environment" = "dev"
  }
}

variable "bucket_info" {
  type = string
  default = "bucket2-dev1106"
}

variable "bucket_customers" {
  type = string
  default = "bucket3-dev1106"
}

