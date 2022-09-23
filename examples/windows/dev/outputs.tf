# ########################
# #
# # BEGIN GENERAL BASELINE OUTPUTS
# #
# #########################

output "pbl" {
  description = "The operating system"
  value       = module.windows-baseline.patch_baseline_label
}

output "servers_evironment" {
  description = "Enviornment of all servers in this module"
  value       = local.env
}

# #########################
# #
# # END GENERAL BASELINE OUTPUTS
# #
# #########################



# #########################
# #
# # BEGIN WINDOWS BASELINE OUTPUTS
# #
# #########################

output "windows_baseline_id" {
  description = "Patch Baseline Id"
  value       = module.windows-baseline.patch_baseline_id
}


output "windows_servers_being_patched" {
  description = "Server falvors that are being patched"
  value       = local.product
}

output "windows_servers_types_of_patches_applied" {
  description = "types of patches applied for windows systems"
  value       = local.classification
}

output "windows_servers_patch_severity" {
  description = "Server patch serverity for windows systems"
  value       = local.severity
}

output "windows_servers_maintenance_schedule" {
  description = "The maintenance_schedule for the windows server"
  value       = local.install_maintenance_window_schedule
}

# #########################
# #
# # END WINDOWS BASELINE OUTPUTS
# #
# #########################




# #########################
# #
# # BEGIN RHEL BASELINE OUTPUTS
# #
# #########################

output "rhel_baseline_id" {
  description = "Patch Baseline Id"
  value       = module.rhel_baseline.patch_baseline_id
}


output "rhel_servers_being_patched" {
  description = "Server falvors that are being patched"
  value       = local.operating_system_rhel
}


output "rhel_servers_maintenance_schedule" {
  description = "The maintenance_schedule for the rhel server"
  value       = local.install_maintenance_window_schedule
}

output "rhel_server_types_classification_severity" {
  description = "types of patches applied for rhel systems"
    value       = module.rhel_baseline.rhel_server_types_classification_severity
  }


# #########################
# #
# # END RHEL BASELINE OUTPUTS
# #
# #########################



# ######### BEGIN SHARED RESOURCES MODULE OUTPUTS ###############

output "patch_topic_arn" {
    value = module.shared-resources.patch_topic_arn
}

output "service_role_arn" {
    value = module.shared-resources.service_role_arn
}

output "role_name" {
    value = module.shared-resources.role_name
    
}

output "bucket-name"{
    value = module.shared-resources.bucket-name
}

output "bucket-suffix"{
    value = module.shared-resources.bucket-suffix
}

# ######### END SHARED RESOURCES MODULE OUTPUTS ###############




# ######### START MAINTANENCE WINDOW OUTPUTS ###############

output "maintanence_window_id" {
    value = module.mw-install-patches.maintanence_window_id
}

output "aws_ssm_maintenance_window_task_id" {
    value = module.mw-install-patches.aws_ssm_maintenance_window_task_id
}

output "aws_ssm_maintenance_window_task_arn" {
    value = module.mw-install-patches.aws_ssm_maintenance_window_task_arn
}

output "aws_ssm_maintenance_window_target_id" {
    value = module.mw-install-patches.aws_ssm_maintenance_window_target_id
}

# ######### END MAINTANENCE WINDOW OUTPUTS ###############