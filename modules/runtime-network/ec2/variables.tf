variable "project" {
    description = "プロジェクト名"
    type = string
}

variable "environment" {
    description = "環境"
    type = string 
    validation {
        condition = contains(["prod", "stg", "dev"], var.environment)
        error_message = "The environment must be one of 'dev', 'stg', or 'prod'."
    }
}

variable "ver" {
    description = "バージョン"
    type = string
}

variable "domain" {
  type        = string
  description = "ドメイン"
}