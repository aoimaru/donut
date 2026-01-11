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


variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Please specify a valid CIDR block."
  }
}