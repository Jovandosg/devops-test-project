## Security Group
resource "aws_security_group" "devops-test" {
  name   = "devops-teste"
  vpc_id = "vpc-0b2a9ae9d47ead2c0"
  tags = {
    Name        = "devops-test"
    Provisioned = "Terraform"
    Cliente     = "DOT"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.devops-test.id
  cidr_ipv4         = "177.112.149.77/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.devops-test.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.devops-test.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.devops-test.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
