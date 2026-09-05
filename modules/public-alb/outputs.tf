output "target_group_arn" { value = aws_lb_target_group.web.arn }
output "nlb_dns_name" { value = aws_lb.public.dns_name }
