#using aws private,public and security group ID as variables
variable "aws_private" {
  type = string
}
variable "aws_public" {
  type = string
}
variable "security_group_id" {
  type = string
}
#create aws ec2 instance named MYSQL with private subnet
resource "aws_instance" "MYSQL" {
  ami                    = "ami-0a91cd140a1fc148a"
  instance_type          = "t2.micro"
  subnet_id              = var.aws_private
  vpc_security_group_ids = [var.security_group_id]
  key_name = "terraform"
  user_data = file("configure_mysql.sh")
  tags = {
    Name = "MYSQL"
  }

}
#create aws ec2 instance named WORDPRESS with public subnet
resource "aws_instance" "WORDPRESS" {
  ami                    = "ami-0a91cd140a1fc148a"
  instance_type          = "t2.micro"
  subnet_id              = var.aws_public
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name = "terraform"
  tags = {
    Name = "WORDPRESS"
  }

#connect to the WORDPRESS ec2 instance and install WORDPRESS & docker via SSH connection (not a file because the bash script would not now how to invoke the ip address)
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install docker.io -y",
      "sudo systemctl restart docker",
      "sudo systemctl enable docker",
      "sudo docker pull wordpress",
      "sudo docker run --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=${aws_instance.MYSQL.private_ip} -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=root -e WORDPRESS_DB_NAME=wordpressdb -d wordpress"
    ]
 }

  connection {
    type        = "ssh"
    host        = aws_instance.WORDPRESS.public_ip
    user        = "ubuntu"
    private_key = file("terraform.pem")
  }

}
