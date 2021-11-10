resource "aws_instance" "AppAmi" {
    ami   = data.aws_ami.ami.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.app-ami.id]
    
    tags = {
    Name = "${var.component}-ami"
  }
}

resource "aws_security_group" "app-ami" {
  name        = "${var.component}-ami"
  description = "Allow ${var.component}"

  ingress = [
    {
      description      = "ALL"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "ALL"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      security_groups  = []
    }
  ]

  tags = {
    Name = "${var.component}-ami"
  }
}

resource "null_resource" "apps" {
  #triggers = {
  #  abc = timestamp()
  #}
  # remove comment's when you want to run the mongodb null resource
  #triggers = {
   # abc = local.all_instance_ip
  #}
  
  provisioner "remote-exec" {
    connection {
      user     = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["ssh_user"]
      password = jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["ssh_pass"]
      host     = aws_ami.AppAmi.private_ip
    }
    
    inline = [
      "sudo yum install python3-pip -y",
      "sudo pip3 install pip --upgrade",
      "sudo pip3 install ansible==4.1.0",
      "ansible-pull -i localhost -U https://dasarisaikrishna97@dev.azure.com/dasarisaikrishna97/Roboshop/_git/ansible-roboshop.git roboshop-pull.yml -e COMPONENT=${var.component} -e ENV=ENV -e APP_VERSION=${var.APP_VERSION} -e PAT=${jsondecode(data.aws_secretsmanager_secret_version.Dev_secret.secret_string)["PAT"]}"
    ]
  }
  
}