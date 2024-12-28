# Data to get latest AMI ID
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Change this as required
  }
}


# Web Server Instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Change to appropriate instance type
  subnet_id     = aws_subnet.private_web_subnet_a.id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Hello from Web Server!</h1>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "web-server"
  }

}

# App Server Instances
resource "aws_instance" "app_server_1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Change to appropriate instance type
  subnet_id     = aws_subnet.private_app_subnet_a.id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
               echo "<h1>Hello from App Server 1!</h1><br><p> This is the application route ` /api`</p>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "app-server-1"
  }

}


resource "aws_instance" "app_server_2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Change to appropriate instance type
  subnet_id     = aws_subnet.private_app_subnet_a.id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]
      user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
               echo "<h1>Hello from App Server 2!</h1><br><p> This is the application route `/api`</p>" > /var/www/html/index.html
              EOF
  tags = {
    Name = "app-server-2"
  }

}

# ==============================================================================
# Register Instances to target groups
# ==============================================================================
resource "aws_lb_target_group_attachment" "web_tg_attach" {
    target_group_arn = aws_lb_target_group.web_tg.arn
    target_id        = aws_instance.web_server.id
  port = 80
}

resource "aws_lb_target_group_attachment" "app_tg_attach_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server_1.id
  port = 80

}

resource "aws_lb_target_group_attachment" "app_tg_attach_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server_2.id
  port = 80
}