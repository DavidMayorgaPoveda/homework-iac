data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-ssm-role"
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.project_name}-${var.environment}-instance-profile"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en">
      <head><meta charset="utf-8"><title>Infrastructure as Code</title></head>
      <body><h1>Hi, I am ${var.your_name} and this is my IaC</h1></body>
    </html>
    HTML
  EOF

  user_data_replace_on_change = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-web"
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }

  depends_on = [aws_iam_role_policy_attachment.ssm_core]
}
