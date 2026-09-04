output "public_nlb_sg_id" { value = aws_security_group.public_nlb.id }
output "web_sg_id" { value = aws_security_group.web.id }
output "private_nlb_sg_id" { value = aws_security_group.private_nlb.id }
output "app_sg_id" { value = aws_security_group.app.id }
output "db_sg_id" { value = aws_security_group.db.id }
