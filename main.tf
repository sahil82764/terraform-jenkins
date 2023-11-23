provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "foo" {
    ami           = "ami-05fa00d4c63e32376"  # Specify the desired AMI
    instance_type = "t2.micro"
    tags = {
        Name = "TF-Instance"
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y python3-pip
                git clone https://github.com/sahil82764/flask-app.git
                cd flask-app
                pip3 install -r requirements.txt
                python3 app.py
                EOF
}
