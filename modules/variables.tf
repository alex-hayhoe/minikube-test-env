variable "namespace_name" {
  description = "The name of the Kubernetes namespace."
  default     = "default"
}

variable "mysql_root_password" {
  description = "The root password for MySQL."
  default     = "root_password"
}

variable "minio_access_key" {
  description = "The access key for MinIO."
  default     = "access_key"
}

variable "minio_secret_key" {
  description = "The secret key for MinIO."
  default     = "secret_key"
}
