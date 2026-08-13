variable "aws_region" {
  description = "AWS region for all regional resources. us-east-1 is the default for service availability and free-tier friendliness; any commercial region (including me-central-1) works."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix applied to every resource this project creates. Kept as the repo name by default so resources are easy to trace back to this code."
  type        = string
  default     = "aws-security-baseline"
}

variable "alert_email" {
  description = "Email address that receives GuardDuty finding alerts and budget notifications. No default on purpose - set it in terraform.tfvars. The SNS subscription must be confirmed once from the inbox after apply."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address, e.g. you@example.com."
  }
}

variable "log_retention_days" {
  description = "Days to keep CloudTrail and AWS Config logs in S3 before the lifecycle rule expires them."
  type        = number
  default     = 365

  validation {
    condition     = var.log_retention_days >= 1
    error_message = "log_retention_days must be at least 1."
  }
}

variable "guardduty_severity_threshold" {
  description = "Minimum GuardDuty finding severity that triggers an email alert. GuardDuty scores findings from 0.1 to 8.9; 7.0 and above is High. The default alerts on High and Critical findings only."
  type        = number
  default     = 7

  validation {
    condition     = var.guardduty_severity_threshold >= 0 && var.guardduty_severity_threshold <= 9
    error_message = "guardduty_severity_threshold must be between 0 and 9."
  }
}

variable "monthly_budget_amount" {
  description = "Monthly cost budget in USD. Email alerts fire at 80% of actual spend and 100% of forecasted spend."
  type        = number
  default     = 10

  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "monthly_budget_amount must be greater than 0."
  }
}
