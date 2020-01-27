resource "aws_instance" "jenkins-instance" {
  #ami                    = "ami-0ecf7c25b58c4cf45"
  ami                    = "ami-0dcb990d48ff0c6e1"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.mainsg.id}"]
  subnet_id              = "${local.pub_sub_ids[0]}"
  key_name               = "${var.key_name}"

  #key_name  = "${aws_key_pair.deployer.key_name}"
  user_data = "${file("jenkins.sh")}"

  #associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Instance"
  }
  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.root_disk_size_gb}"
    delete_on_termination = true
  }
  connection {
    host        = "${self.public_ip}"
    type        = "ssh"
    user        = "${var.linux_username}"
    private_key = "${file("${var.key_file_path}")}"
    timeout     = "10m"
  }

  /*provisioner "file" {
    source      = "${path.module}/jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo The instance is ready to be provisioned",
      "chmod +x /tmp/jenkins.sh",
      "source /tmp/jenkins.sh",
    ]
  }*/
}
