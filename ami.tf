resource "aws_ami_from_instance" "ami" {
  depends_on         = [null_resource.apps]
  name               = "${var.component}-${var.APP_VERSION}"
  source_instance_id = aws_instance.AppAmi.id
}