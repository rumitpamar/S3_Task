variable "bucket_name" {
  description = "bucket name"
  default     = "s3-task-promact"
}

variable "Name_of_access_tier" {
  description = "please provide name of the tier"
  default     = "ARCHIVE_ACCESS"
}

variable "storage_class_name" {
  description = "Please provide the name of the storage class"
  default     = "INTELLIGENT_TIERING"

}
variable "allowed_methods" {
  default = ["GET", "HEAD"]
}
variable "cached_methods" {
  default = ["GET", "HEAD"]
}

variable "query_string" {
  default = "false"
}