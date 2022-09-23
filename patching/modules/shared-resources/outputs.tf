output "patch_topic_arn" {
    value = aws_sns_topic.patch_baseline_topic.arn
}

output "service_role_arn" {
    value = aws_iam_role.ssm_maintenance_window_role.arn
}

output "role_name" {
    value = aws_iam_role.ssm_maintenance_window_role.name
    
}

output "bucket-name"{
    value = aws_s3_bucket.patch_log_bucket.id
}


output "bucket-suffix"{
    value = random_string.bucket-suffix.result
}

output "patch_baseline_label"{
    value = "cf-tf-ssm-pblm"
}
