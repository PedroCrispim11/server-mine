variable "aws_region" {
  default = "us-east-1" # Altere se preferir outra região
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  default     = "t3.small" 
}

variable "key_name" {
  description = "Nome do par de chaves SSH criado na AWS"
  type        = string
}