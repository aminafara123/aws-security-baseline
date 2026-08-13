# ---------------------------------------------------------------------------
# IAM hardening: a strict account password policy and an IAM Access Analyzer
# that flags resources shared outside the account.
# ---------------------------------------------------------------------------

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}

resource "aws_accessanalyzer_analyzer" "account" {
  analyzer_name = "${var.project_name}-analyzer"
  type          = "ACCOUNT"
}
