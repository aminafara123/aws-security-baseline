# ---------------------------------------------------------------------------
# Account-level S3 public access block: no bucket in this account can be made
# public, regardless of its individual bucket settings. The log buckets in
# this project also carry their own per-bucket blocks for defence in depth.
# ---------------------------------------------------------------------------

resource "aws_s3_account_public_access_block" "account" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
