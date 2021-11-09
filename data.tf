data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "^Centos-7*"
  owners           = ["973714476881"]
  }
  
data "aws_secretsmanager_secret" "Dev_secret" {
  name = "dev"
}

data "aws_secretsmanager_secret_version" "Dev_secret" {
  secret_id = data.aws_secretsmanager_secret.Dev_secret.id
}

data "aws_route53_zone" "route53" {
  name         = "krishna.roboshop"
  private_zone = true
}