provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "foo" {
    ami           = "ami-05fa00d4c63e32376" 
    instance_type = "t2.micro"
    tags = {
        Name = "TF-Instance"
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y python3-pip

                # Custom wait mechanism (example, use a tool like wait-for-it in production)
                until nc -zv localhost 80; do sleep 1; done

                git clone https://github.com/sahil82764/flask-app.git
                cd flask-app
                pip3 install -r requirements.txt
                python3 app.py
                EOF

    # IAM role for the instance with necessary permissions (customize based on your needs)
    iam_instance_profile = "CICD-User"
}
