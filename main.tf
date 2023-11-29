locals {
  key_prefix = "iam/${var.user_name}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
  }

  backend "s3" {
    bucket = "tf-statefiles-bucket"
    key    = local.key_prefix != "" ? "${local.key_prefix}/terraform.tfstate" : "terraform.tfstate"
    region = "ap-south-1"
  }
}

#iam user creation
resource "aws_iam_user" "iam-user" {
  name = "${var.user_name}"

  tags = {
    name = var.tags
  }
}

#access key
resource "aws_iam_access_key" "access_key" {
	user = aws_iam_user.iam-user.name
}

data "aws_s3_bucket" "users_bucket" {
  bucket = "users-key-tf"
}
# Create the object inside the token bucket
resource "aws_s3_bucket_object" "tokens" {
  bucket                 = data.aws_s3_bucket.users_bucket.bucket
  key                    = var.keys
  server_side_encryption = "AES256"
  content_type           = "text/plain"
  content                = <<EOF
access_id: ${aws_iam_access_key.access_key.id}
access_secret: ${aws_iam_access_key.access_key.secret}
EOF

  depends_on = [aws_iam_access_key.access_key]
}



#attaching iam policy
resource "aws_iam_user_policy_attachment" "user-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  user = aws_iam_user.iam-user.name
}


/*
resource "aws_iam_group" "iam_group" {
    name = "dev"
}

resource "aws_iam_policy_attachment" "group_policy-attach" {
    name = "dev-group_policy-attach"
    groups = ["${aws_iam_group.iam_group.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# add users to a group
 
resource "aws_iam_group_membership" "dev-users" {
    name = "dev-users"
    users = [
        "${aws_iam_user.iam-user.name}",
    ]
    group = "${aws_iam_group.iam_group.name}"
}

*/
