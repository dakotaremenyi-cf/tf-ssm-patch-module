
output "tags" {
    value = var.tags
}

output "maintanence_window_id" {
    value = aws_ssm_maintenance_window.install_window.id
}

output "aws_ssm_maintenance_window_task_id" {
    value = aws_ssm_maintenance_window_task.task_install_patches.id
}

output "aws_ssm_maintenance_window_task_arn" {
    value = aws_ssm_maintenance_window_task.task_install_patches.arn
}

output "aws_ssm_maintenance_window_target_id" {
    value = aws_ssm_maintenance_window_target.target_install.id
}

