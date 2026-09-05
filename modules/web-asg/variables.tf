variable "environment" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "web_sg_id" { type = string }
variable "iam_instance_profile_name" { type = string }
