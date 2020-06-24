provider "aws" {
profile = "default"
region  = "us-east-1"
}

resource "aws_key_pair" "keym" {
key_name   = "tundekey"
 public_key = file(var.path_to_public_key)
}

resource "aws_instance" "terra" {
ami           = "ami-09d95fab7fff3776c"
instance_type = "t2.micro"
key_name = "tundekey"


 connection {
  type        = "ssh"
  host        = aws_instance.terra.private_ip
  user        = "ec2-user"
  private_key = file(var.path_to_private_key)
   
  }


provisioner "remote-exec" {
     inline = [
         "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo",
         "sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key",
         "yum install jenkins -y"

    
        ]


 }

}

#output "ip" { value = "http://${aws_instance.terra.public_ip}:8080 connect ssh -i tundekey root@${aws_instance.terra.public_ip}"}

#resource "aws_security_group" "allow_ssh" {
 # name        = "allow_ssh"
  #description = "Allow ssh inbound traffic"
  #vpc_id      = "${aws_vpc.main.id}"

  #ingress {
    
 #   from_port   = 22
 #   to_port     = 22
 #   protocol    = "tcp"
 #   cidr_blocks = ["0.0.0.0/0"]
 # }

 # egress {
 #   from_port   = 0
 #   to_port     = 0
 #   protocol    = "-1"
 #   cidr_blocks = ["0.0.0.0/0"]
 # }

  
#}