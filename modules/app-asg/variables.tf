variable "environment" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "app_sg_id" { type = string }
variable "iam_instance_profile_name" { type = string }
