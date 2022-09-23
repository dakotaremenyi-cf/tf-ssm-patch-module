output "patch_baseline_id" {
  description = "Patch Baseline Id"
  value       = aws_ssm_patch_baseline.baseline.id
}

output "operating_system" {
  description = "The operating system"
  value = local.operating_system
}

output "patch_baseline_label" {
  description = "Patch Baseline Label Output"
  value = var.patch_baseline_label
}


output "rhel_server_types_classification_severity" {
  description = "types of patches applied for rhel systems"
    value       = [for i in aws_ssm_patch_baseline.baseline.approval_rule[0].patch_filter : {
    name        = lower(i.key)
    valueFrom   = i.values
  }]
}


