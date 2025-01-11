#
# bastion used to test internal ALB
#
resource "aws_security_group" "bastion_sg" {
  count = var.enable_bastion == true ? 1 : 0

  name        = format("%s-bastion-vm-sg", var.project_name)
  description = "Grant access to the bastion vm from my public ip"
  vpc_id      = data.aws_ssm_parameter.vpc.value

  ingress {
    description = "ssh from my public ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = format("%s-bastion-vm-sg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_key_pair" "bastion_ssh_key" {
  count = var.enable_bastion == true ? 1 : 0

  key_name   = format("%s-bastion-ssh-key", var.project_name)
  public_key = file(var.ssh_public_key_file)
}

resource "aws_instance" "bastion" {
  count = var.enable_bastion == true ? 1 : 0

  ami                         = data.aws_ami.amazon_linux_arm64.id
  instance_type               = "t4g.nano" # ARM
  subnet_id                   = data.aws_ssm_parameter.public_subnets[0].value
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg[0].id]
  key_name                    = aws_key_pair.bastion_ssh_key[0].key_name # ec2-user

  tags = merge(
    {
      Name = format("%s-bastion-vm", var.project_name)
    },
    var.common_tags
  )

}