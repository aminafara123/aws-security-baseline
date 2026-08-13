# ---------------------------------------------------------------------------
# EBS encryption by default: every new EBS volume and snapshot copy created
# in this region is encrypted, without relying on anyone remembering to tick
# the box. Regional setting - repeat per region in a multi-region rollout.
# ---------------------------------------------------------------------------

resource "aws_ebs_encryption_by_default" "main" {
  enabled = true
}
