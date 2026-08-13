output "cloudtrail_arn" {
  description = "ARN of the multi-region CloudTrail trail."
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket that receives CloudTrail logs."
  value       = aws_s3_bucket.cloudtrail.id
}

output "config_bucket_name" {
  description = "Name of the S3 bucket that receives AWS Config snapshots and history."
  value       = aws_s3_bucket.config.id
}

output "config_recorder_name" {
  description = "Name of the AWS Config configuration recorder."
  value       = aws_config_configuration_recorder.main.name
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector (needed to generate sample findings for testing)."
  value       = aws_guardduty_detector.main.id
}

output "security_alerts_topic_arn" {
  description = "ARN of the SNS topic that delivers GuardDuty alert emails."
  value       = aws_sns_topic.security_alerts.arn
}

output "securityhub_cis_subscription_arn" {
  description = "ARN of the Security Hub subscription to the CIS AWS Foundations Benchmark standard."
  value       = aws_securityhub_standards_subscription.cis.id
}

output "access_analyzer_arn" {
  description = "ARN of the account-scope IAM Access Analyzer."
  value       = aws_accessanalyzer_analyzer.account.arn
}

output "budget_name" {
  description = "Name of the monthly cost budget."
  value       = aws_budgets_budget.monthly.name
}
