# ---------------------------------------------------------------------------
# Alerting: an SNS topic with an email subscription, fed by an EventBridge
# rule that matches GuardDuty findings at or above the severity threshold.
# An input transformer reshapes the raw finding JSON into a short
# human-readable email body.
# ---------------------------------------------------------------------------

resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-security-alerts"
}

resource "aws_sns_topic_policy" "security_alerts" {
  arn = aws_sns_topic.security_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEventBridgePublish"
        Effect    = "Allow"
        Principal = { Service = "events.amazonaws.com" }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.security_alerts.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.guardduty_findings.arn
          }
        }
      }
    ]
  })
}

# Email subscriptions are never auto-confirmed: after `terraform apply`, AWS
# emails a confirmation link to var.alert_email that must be clicked once.
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "${var.project_name}-guardduty-high-severity"
  description = "Matches GuardDuty findings with severity >= ${var.guardduty_severity_threshold}"

  event_pattern = jsonencode({
    source        = ["aws.guardduty"]
    "detail-type" = ["GuardDuty Finding"]
    detail = {
      severity = [{ numeric = [">=", var.guardduty_severity_threshold] }]
    }
  })
}

resource "aws_cloudwatch_event_target" "guardduty_to_sns" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "${var.project_name}-sns"
  arn       = aws_sns_topic.security_alerts.arn

  # The input transformer turns the raw finding JSON into a short plain-text
  # message, so the alert email is readable on a phone instead of being a
  # wall of JSON. The template must reach the API as one quoted single-line
  # string: newlines written as \n escape sequences, but the <placeholder>
  # angle brackets left literal. jsonencode() is unusable here because it
  # escapes < and > to </>, which breaks placeholder matching.
  input_transformer {
    input_paths = {
      account     = "$.account"
      region      = "$.region"
      severity    = "$.detail.severity"
      type        = "$.detail.type"
      description = "$.detail.description"
      time        = "$.time"
      finding_id  = "$.detail.id"
    }

    input_template = "\"GuardDuty finding in account <account> (<region>)\\n\\nSeverity: <severity>\\nType: <type>\\nTime: <time>\\nFinding ID: <finding_id>\\n\\n<description>\\n\\nOpen the GuardDuty console in <region> to investigate.\""
  }
}
