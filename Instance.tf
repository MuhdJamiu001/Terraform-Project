resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = "InstanceKey"
  subnet_id              = aws_subnet.project-pub-1.id
  vpc_security_group_ids = [aws_security_group.project-sg.id]

  tags = {
    Name = "Web-Project"
  }

}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}
