
locals {
  product                             = tolist(["WindowsServer2016", "WindowsServer2012R2","WindowsServer2019"])
  classification                      = tolist(["CriticalUpdates", "DefinitionUpdates", "SecurityUpdates", "UpdateRollups"])
  severity                            = tolist(["Critical", "Important"])
  env                                 = "dev"
  operating_system                    = "windows"
  operating_system_rhel               = "rhel"
  install_maintenance_window_schedule = "cron(0 0 12 1/1 * ? * )"
  patch_groups                        = tolist(["INSTALL"])

  tags = {
    terraform = "true"
    owner     = "coalfire"
    team      = "sre"
  }

}

################################################################################################################################################################################
#
# SHARED RESOURCES DEPLOY IAM ROLE, S3 BUCKET FOR STORING PATCHING LOGS, AND A SNS TOPIC THAT YOU CAN SUBSCRIBE TO FOR PATCHING NOTIFICATIONS (MANUAL)
#
################################################################################################################################################################################


module "shared-resources" {

  source           = "../../../patching/modules/shared-resources"
  env              = local.env
  service_role_arn = module.shared-resources.service_role_arn
  notification_arn = module.shared-resources.patch_topic_arn
  operating_system = local.operating_system
  bucket           = lower("${module.shared-resources.patch_baseline_label}-${local.env}-patching-logs-bucket-${module.shared-resources.bucket-suffix}")
  role_name        = lower("${module.shared-resources.patch_baseline_label}-${local.env}-patching-install-role")

}

######################################
# Create Patch Baselines for Windows 
######################################

module "windows-baseline" {
  source           = "../../../patching/modules/baselines/windows"
  patch_group_name = format("%s-%s-%s", local.env, lower(local.operating_system), "install-patchgroup")
  # tags parameters
  env = lower(local.env)

  # patch baseline parameters
  #compliance_level = upper(local.compliance_level)
  description      = "Windows - PatchBaseLine - Apply Critical Security Updates"
  tags             = merge(local.tags, { environment = local.env })

  # define rules inside patch baseline
  baseline_approval_rules = [
    {
      approve_after_days  = 0
      compliance_level    = "UNSPECIFIED"
      enable_non_security = false
      patch_baseline_filters = [

        {
          name   = "PRODUCT"
          values = local.product #ANOTHER OPTION -> ["WindowsServer2012R2", "WindowsServer2016", "WindowsServer2019", "WindowsServer2022"]
        },
        {
          name   = "CLASSIFICATION"
          values = local.classification #ANOTHER OPTION -> ["CriticalUpdates", "DefinitionUpdates", "SecurityUpdates", "UpdateRollups"]
        },

        {
          name   = "MSRC_SEVERITY"
          values = local.severity #ANOTHER OPTION -> ["Critical", "Important", "Moderate"]
        }
      ]
    }
  ]

}


module "mw-install-patches" {
  source                              = "../../../patching/modules/maintanence-windows/install-window"
  env                                 = local.env
  operating_system                    = lower(local.operating_system)
  role_name                           = module.shared-resources.role_name
  service_role_arn                    = module.shared-resources.service_role_arn
  install_maintenance_window_schedule = local.install_maintenance_window_schedule
  patch_groups                        = ["INSTALL"]
  tags                                = merge(local.tags, { env = local.env }, { ManagedBy = "terraform" }, { operating_system = local.operating_system })
  enable_notification                 = true
  notification_arn                    = module.shared-resources.patch_topic_arn
  bucket                              = lower("${module.shared-resources.patch_baseline_label}-${local.env}-install-logs-bucket")
}



##################################################
#
#                RHEL
#
##################################################


module "rhel_baseline" {
    source = "../../../patching/modules/baselines/linux/rhel"
    env = local.env

} 

module "rhel_maintenance_window" {
    source = "../../../patching/modules/maintanence-windows/install-window"
    env = local.env
    operating_system                    = lower(local.operating_system_rhel)
    role_name                           = module.shared-resources.role_name
    service_role_arn                    = module.shared-resources.service_role_arn
    install_maintenance_window_schedule = local.install_maintenance_window_schedule
    patch_groups                        = ["RHEL"]
    tags                                = merge(local.tags, { env = local.env }, { ManagedBy = "terraform" }, { operating_system = local.operating_system_rhel })
    enable_notification                 = true
    notification_arn                    = module.shared-resources.patch_topic_arn
    bucket                              = lower("${module.shared-resources.patch_baseline_label}-${local.env}-install-logs-bucket-${module.shared-resources.bucket-suffix}")
    }

