Web Project - Terraform
Este projeto utiliza Terraform para provisionar uma instância EC2 com um servidor web na AWS.

Estrutura do Projeto
main.tf: Configuração principal do Terraform, onde estão definidos os recursos a serem provisionados.
variables.tf: Definição de variáveis reutilizáveis para personalizar o projeto (opcional).
outputs.tf: Saídas configuradas, como o IP público da instância EC2.
.gitlab-ci.yml: Arquivo de configuração do pipeline CI/CD no GitLab para automação.
Pré-requisitos
AWS CLI Configurado:
Instale o AWS CLI (Guia de instalação).
Configure suas credenciais:
bash
Copiar código
aws configure
Terraform Instalado:
Baixe e instale o Terraform (Guia de instalação).
Verifique a instalação:
bash
Copiar código
terraform --version
Acesso à AWS:
Certifique-se de que sua conta AWS possui permissões para criar instâncias EC2 e configurar redes.
Fluxo de Configuração e Deploy
Inicializar o Terraform:

No diretório do projeto, execute:
bash
Copiar código
terraform init
Planejar a Infraestrutura:

Gere o plano de execução para verificar as alterações que serão feitas:
bash
Copiar código
terraform plan
Aplicar as Alterações:

Provisione os recursos na AWS:
bash
Copiar código
terraform apply -auto-approve
O IP público da instância EC2 será exibido no final.
Destruir os Recursos (opcional):

Para remover todos os recursos criados:
bash
Copiar código
terraform destroy -auto-approve
Configuração do CI/CD no GitLab
Este projeto inclui um pipeline automatizado para gerenciar a infraestrutura via GitLab CI/CD.

Estrutura do Pipeline
Estágios:

validate: Valida o código Terraform.
plan: Gera o plano de execução e armazena como artefato.
apply: Aplica as mudanças (executado manualmente).
Arquivo .gitlab-ci.yml: Configuração do pipeline:

yaml
Copiar código
image: debian:latest

stages:
  - validate
  - plan
  - apply

variables:
  TF_VAR_region: "us-east-1"
  TF_IN_AUTOMATION: "true"

before_script:
  - apt-get update && apt-get install -y wget unzip
  - wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_amd64.zip
  - unzip terraform_1.5.5_linux_amd64.zip
  - mv terraform /usr/local/bin/
  - terraform --version

validate:
  stage: validate
  script:
    - terraform init
    - terraform fmt -check
    - terraform validate

plan:
  stage: plan
  script:
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - tfplan
    expire_in: 1 hour

apply:
  stage: apply
  script:
    - terraform init
    - terraform apply -auto-approve tfplan
    - terraform output public_ip
  when: manual
Configuração no GitLab
Acesse Settings > CI/CD > Variables no repositório GitLab.
Adicione as variáveis:
AWS_ACCESS_KEY_ID: Sua chave de acesso AWS.
AWS_SECRET_ACCESS_KEY: Sua chave secreta AWS.
TF_VAR_region: Região da AWS (ex.: us-east-1).
Executar o Pipeline
Faça o commit do arquivo .gitlab-ci.yml:
bash
Copiar código
git add .gitlab-ci.yml
git commit -m "Add GitLab CI/CD pipeline"
git push origin main
Acesse CI/CD > Pipelines no GitLab e execute os estágios.
Visualizar o IP Público
Após o estágio apply, o IP público da instância EC2 será exibido nos logs.
Copie o IP e acesse no navegador para verificar o servidor web.
