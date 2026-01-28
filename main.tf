############################
# IAM GROUP
############################
#resource "aws_iam_group" "dev_group" {
  #name = "developers-group"
#}

############################
# IAM USER
############################
#resource "aws_iam_user" "dev_user" {
  #name = "terraform-user"
#}

############################
# GROUP MEMBERSHIP
############################
#resource "aws_iam_group_membership" "group_membership" {
  #name  = "dev-group-membership"
  #users = [aws_iam_user.dev_user.name]
  #group = aws_iam_group.dev_group.name
#}


############################
# S3 BUCKET
############################
#resource "aws_s3_bucket" "website_bucket" {
  #bucket = var.bucket_name

  #tags = {
    #Environment = var.environment
  #}
#}


resource "aws_s3_bucket" "website_bucket" {
  bucket = "mon-site-mohamed"

  tags = {
    Environment = var.environment
  }
}

############################
# STATIC WEBSITE CONFIG
############################
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

############################
# UPLOAD WEBSITE FILES
############################
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/site-web", "**/*")

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "${path.module}/site-web/${each.value}"

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
    },
    regex("\\.([^.]+)$", each.value)[0],
    "application/octet-stream"
  )
}

############################
# PUBLIC ACCESS
############################
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
    }]
  })
}

############################
# OUTPUT
############################
output "website_url" {
  value = "http://${aws_s3_bucket.website_bucket.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}


#resource "aws_iam_group_policy_attachment" "s3_access" {
#group      = aws_iam_group.dev_group.name
  #policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#}
