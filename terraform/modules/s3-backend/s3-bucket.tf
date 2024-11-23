resource "aws_s3_bucket" "state" {
  provider      = aws.source
  force_destroy = var.force_destroy
  bucket        = format("%s-%s-%s-tf-state", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"])

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-tf-state", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"]) }
  )
}

resource "aws_s3_bucket_versioning" "state" {
  provider   = aws.source
  bucket     = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "backup" {
  provider      = aws.backup
  force_destroy = var.force_destroy
  bucket        = format("%s-%s-%s-tf-state-backup", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"])

  tags = merge(
    var.common_tags,
    { Name = format("%s-%s-%s-tf-state-backup", var.common_tags["environment"], var.common_tags["project"], var.common_tags["owner"]) }
  )
}

resource "aws_s3_bucket_versioning" "backup" {
  provider   = aws.backup
  bucket     = aws_s3_bucket.backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "state" {
  depends_on = [aws_s3_bucket_versioning.state,aws_s3_bucket_versioning.backup]
  provider = aws.source
  bucket   = aws_s3_bucket.state.id
  role     = aws_iam_role.replication.arn

  rule {
    id     = "StateReplicationRule"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.backup.arn
      storage_class = "STANDARD"
    }
  }
}
