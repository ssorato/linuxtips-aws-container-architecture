#
# bastion used to test internal Loki lb
#
resource "aws_security_group" "bastion_sg" {
  name        = format("%s-bastion-vm-sg", var.project_name)
  description = "Grant access to the bastion vm from my public ip"
  vpc_id      = data.aws_ssm_parameter.vpc.value

  ingress {
    description = "ssh from my public ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
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
  key_name   = format("%s-bastion-ssh-key", var.project_name)
  public_key = file(var.ssh_public_key_file)
}

resource "aws_instance" "bastion" {
  ami                         = "ami-06b21ccaeff8cd686" # Amazon Linux 2023
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_ssm_parameter.public_subnet[0].value
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_ssh_key.key_name

  tags = merge(
    {
      Name = format("%s-bastion-vm", var.project_name)
    },
    var.common_tags
  )

}