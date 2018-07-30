provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}

variable "ec2_type_master" {
   default = "t2.xlarge"
}

variable "ec2_type_workers" {
  default = "t2.medium"
}

resource "aws_instance" "hadoop-master" {

  tags {
    "Name"        = "hadoop-master"
  }
  ami             = "ami-6871a115"
  instance_type   = "${var.ec2_type_master}"
  key_name        = "clouderav2-aws"
  security_groups = ["Cloudera"]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/clouderav2-aws.pem")}"
  }

  provisioner "file" {
    source      = "scripts/global_init.sh"
    destination = "/tmp/global_init.sh"
  }

  provisioner "file" {
    source = "scripts/master_init.sh"
    destination = "/tmp/master_init.sh"
  }

  provisioner "file" {
    source = "scripts/mysql_secure_install_automated.sh"
    destination = "/tmp/mysql_secure_install_automated.sh"
  }

  provisioner "file" {
    source = "utils/cloudera_database.sql"
    destination = "/tmp/cloudera_database.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/global_init.sh",
      "bash /tmp/master_init.sh"
    ]
  }

}

resource "aws_instance" "hadoop-worker" {

  count = 4

  tags {
    "Name"        = "hadoop-worker-${count.index}"
  }
  ami             = "ami-6871a115"
  instance_type   = "${var.ec2_type_workers}"
  key_name        = "clouderav2-aws"
  security_groups = ["Cloudera"]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  ebs_block_device{
    device_name = "/dev/sdb"
    volume_size = 1024
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/clouderav2-aws.pem")}"
  }

  provisioner "file" {
    source      = "scripts/global_init.sh"
    destination = "/tmp/global_init.sh"
  }

  provisioner "file" {
    source      = "scripts/workers_init.sh"
    destination = "/tmp/workers_init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/global_init.sh",
      "bash /tmp/workers_init.sh"
    ]
  }

}