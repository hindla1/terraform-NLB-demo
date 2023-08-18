resource "aws_instance" "web" {
  ami                         = var.AMI
  instance_type               = var.INSTANCE_TYPE
  subnet_id                   = aws_subnet.my-pub-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.my-sg-1.id]
  key_name = aws_key_pair.my-key.key_name


    provisioner "remote-exec" {
     inline = [
        "sudo yum update -y",
        "sudo yum install nginx -y",
        "sudo yum install wget unzip -y",
        "sudo wget https://www.free-css.com/assets/files/free-css-templates/download/page294/jobentry.zip -P /usr/share/nginx/html/",
        "sudo unzip /usr/share/nginx/html/jobentry.zip -d /usr/share/nginx/html/",
        "sudo rm -rf /usr/share/nginx/html/index.html",
        "sudo mv -f /usr/share/nginx/html/job-portal-website-template/* /usr/share/nginx/html/",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx",
      ]
     }
    connection {
         host = self.public_ip
         type = "ssh"
         user = "ec2-user"
         private_key = file("/home/ec2-user/.ssh/id_rsa")

      }

  tags = {
    Name = "pub-server"

  }

}



resource "aws_key_pair" "my-key" {
   key_name = "my-tf-demo1"
  public_key = file("/home/ec2-user/.ssh/id_rsa.pub")
}


#resource "aws_instance" "app" {
#  ami                         = var.AMI
#  instance_type               = var.INSTANCE_TYPE
#  subnet_id                   = aws_subnet.my-private-subnet.id
#  associate_public_ip_address = false
#  vpc_security_group_ids      = [aws_security_group.my-sg-1.id]

#  tags = {
#    Name = "Private-server"
#  }

#}


resource "aws_security_group" "my-sg-1" {
  name = "my-sg-1"
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


}

