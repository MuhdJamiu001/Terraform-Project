resource "aws_key_pair" "project-key" {
  key_name   = "InstanceKey"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvFJmspHWZ2c7tL2BR5kEtnPF4mTSybDeMf1o/UNyFf macbook@MuhdJamiu.local"
}