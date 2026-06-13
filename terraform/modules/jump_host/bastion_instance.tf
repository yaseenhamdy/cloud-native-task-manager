data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = var.subnet_id

  key_name = aws_key_pair.bastion_key.key_name

  vpc_security_group_ids = [aws_security_group.bastion_SG.id]

  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  
  # Install kubectl
  curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.10/2026-04-08/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mkdir -p /usr/local/bin && mv ./kubectl /usr/local/bin/kubectl

  # Install AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
 

 # git installation
  sudo dnf install -y git

 # clone the repo 
  git clone https://github.com/yaseenhamdy/cloud-native-task-manager.git /home/ec2-user/cloud-native-task-manager
  chown -R ec2-user:ec2-user /home/ec2-user/cloud-native-task-manager

EOF

  iam_instance_profile = aws_iam_instance_profile.bastion_role_profile.name


  tags = {
    Name = "Bastion"
  }
}
