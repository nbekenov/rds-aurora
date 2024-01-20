variable "database_name" {
  type        = string
  description = "database_name"
  default     = "aurora-db"
}

variable "admin_user_name" {
  type        = string
  description = "admin_user_name"
  default     = "aurora_admin"
}

variable "engine_version" {
  type        = string
  description = "postgresql engine_version"
  default     = "15.4"
}

variable "max_capacity" {
  type        = number
  description = "max scaling capacity"
  default     = 4
}

variable "min_capacity" {
  type        = number
  description = "min scaling capacity"
  default     = 2

}

variable "vpc_name" {
  type        = string
  description = "vpc_name"
  default     = "main-vpc"
}