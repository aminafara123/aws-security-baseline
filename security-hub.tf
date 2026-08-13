# ---------------------------------------------------------------------------
# Security Hub: aggregates findings from GuardDuty, Config, and Access
# Analyzer, and runs automated checks against the CIS AWS Foundations
# Benchmark.
# ---------------------------------------------------------------------------

resource "aws_securityhub_account" "main" {
  # Standards are opted into explicitly below instead of letting Security Hub
  # auto-enable its defaults, so what runs in the account matches this code.
  enable_default_standards = false
}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0"

  depends_on = [aws_securityhub_account.main]
}
