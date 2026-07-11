resource "aws_flow_log" "flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id

  tags = {
    Name       = "${var.application_name}_flow_logs"
    managed_by = "terraform"
  }
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  #checkov:skip=CKV_AWS_158:Not encrypting.
  name              = "${var.application_name}_flow_logs"
  retention_in_days = 365
  skip_destroy      = false

  tags = {
    Name       = "${var.application_name}_flow_logs_group"
    managed_by = "terraform"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs" {
  name               = "${var.application_name}_flow_logs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name       = "${var.application_name}_flow_logs_role"
    managed_by = "terraform"
  }
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      aws_cloudwatch_log_group.flow_logs.arn,
      "${aws_cloudwatch_log_group.flow_logs.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "flow_logs" {
  name   = "${var.application_name}_flow_logs_policy"
  role   = aws_iam_role.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs.json
}
