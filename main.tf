# Configurar o provider AWS
provider "aws" {
  region = "us-east-1"
}

# Configurar backend remoto para armazenar o estado
terraform {
  backend "s3" {
    bucket         = "web-project-tfstate"
    key            = "terraform/state"
    region         = "us-east-1"
  }
}

# Criar um grupo de segurança
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

# Criar uma instância EC2 com script de inicialização
resource "aws_instance" "web_server_1" {
  ami           = "ami-07bc5cc4add81dad9" # Parâmetro especificado
  instance_type = "t4g.micro"

  # Associar o Security Group criado
  security_groups = [aws_security_group.web_sg.name]

  # Configurar um script de inicialização
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "Hello, World!" > /var/www/html/index.html
              EOF

  # Definir tags para a instância
  tags = {
    Name = "WebServer"
  }
}
