# ---------------------------------------------------------------------------
# GuardDuty: continuous threat detection over CloudTrail events, VPC flow
# logs, and DNS query logs. Findings feed the EventBridge rule in
# alerting.tf.
# ---------------------------------------------------------------------------

resource "aws_guardduty_detector" "main" {
  enable = true

  # Publish findings to EventBridge as quickly as GuardDuty allows so alert
  # emails arrive promptly (default is every six hours).
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}
