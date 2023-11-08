variable "bucket_auth" {
  type = string
  default = "bucket1-prod1106"
}

variable "bucket_info" {
  type = string
  default = "bucket2-prod1106"
}

variable "bucket_customers" {
  type = string
  default = "bucket3-prod1106"
}

variable "bucket_tags" {
  type = map(string)
  default = {
    "Environment" = "prod"
  }
}