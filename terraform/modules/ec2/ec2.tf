resource "aws_iam_role_policy" "ec2_ecr_role" {
  name = var.iam_role_name
  role = aws_iam_role.ecr_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "ecr:PutLifecyclePolicy",
                "ecr:PutImageTagMutability",
                "ecr:StartImageScan",
                "ecr:CreateRepository",
                "ecr:PutImageScanningConfiguration",
                "ecr:GetAuthorizationToken",
                "ecr:UploadLayerPart",
                "ecr:BatchDeleteImage",
                "ecr:DeleteLifecyclePolicy",
                "ecr:DeleteRepository",
                "ecr:PutImage",
                "ecr:UntagResource",
                "ecr:SetRepositoryPolicy",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:InitiateLayerUpload",
                "ecr:DeleteRepositoryPolicy",
                "ecr:ReplicateImage"
            ],
            "Resource": "arn:aws:ecr:*:674528447826:repository/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "ecr:DeleteRegistryPolicy",
                "ecr:PutRegistryPolicy",
                "ecr:PutReplicationConfiguration"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ecr_role" {
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ecr.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.profile_name
  role = aws_iam_role.ecr_role.name
}

resource "aws_instance" "webapp" {
  ami           = var.ami
  count         = var.ec2_count
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  user_data     = file("../modules/ec2/userdata.sh")
  security_groups = ["$var.instance_sg"]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = var.public_ip

  tags = {
    Name = var.name
  }
}