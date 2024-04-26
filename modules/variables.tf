variable "namespace_name" {
  description = "The name of the Kubernetes namespace."
  default     = "dev"
}

variable "mysql_root_password" {
  description = "The root password for MySQL."
  default     = "root_password"
}

variable "mysql_username" {
  description = "The username for MySQL."
  default     = "default"
}

variable "mysql_db_name" {
  description = "The db name for MySQL."
  default     = "default"
}

variable "minio_access_key" {
  description = "The access key for MinIO."
  default     = "access_key"
}

variable "minio_secret_key" {
  description = "The secret key for MinIO."
  default     = "secret_key"
}
