
variable "project" {
  type        = string
  description = "プロジェクト名"
}

variable "environment" {
  type        = string
  description = "環境名"
}

variable "ver" {
  type        = string
  description = "アプリケーションのバージョン"
}

variable "domain" {
  type        = string
  description = "ドメイン"
}

variable "jwt_private_key_base64" {
  description = "Base64 encoded JWT private key"
  type        = string
  sensitive   = true
}

variable "jwt_public_key_base64" {
  description = "Base64 encoded JWT public key"
  type        = string
  sensitive   = true
}

variable "jwt_refresh_private_key_base64" {
  description = "Base64 encoded JWT refresh private key"
  type        = string
  sensitive   = true
}

variable "jwt_refresh_public_key_base64" {
  description = "Base64 encoded JWT refresh public key"
  type        = string
  sensitive   = true
}