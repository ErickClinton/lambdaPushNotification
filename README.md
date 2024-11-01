# lambdaPush

Este projeto contém o código-fonte e os arquivos de suporte para uma aplicação serverless que pode ser implantada com o **SAM CLI**.

## Estrutura do Projeto

- **`push-notification`** - Código da função Lambda da aplicação.
- **`events`** - Eventos de invocação para testar a função.
- **`push-notification/tests`** - Testes unitários para o código da aplicação.
- **`template.yaml`** - Arquivo que define os recursos AWS da aplicação.

A aplicação utiliza recursos como funções Lambda e uma API Gateway, definidos no arquivo `template.yaml`. Esse arquivo pode ser atualizado para adicionar recursos AWS e realizar o deploy em conjunto com o código da aplicação.

---

## Pré-requisitos

Para usar o SAM CLI, é necessário ter instalados os seguintes programas:

- **SAM CLI** - [Instruções de Instalação](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
- **Node.js 20** - [Instalar Node.js 20](https://nodejs.org/en/)
- **Docker** - [Instalar Docker](https://hub.docker.com/search/?type=edition&offering=community)

## Deploy da Aplicação

Para compilar e fazer o deploy da aplicação, use os seguintes comandos no terminal:

```bash
sam build
sam deploy --guided
```
Esses comandos irão:

1. Compilar o código da aplicação.
2. Empacotar e fazer o deploy na AWS, solicitando informações como o nome do stack e a região AWS para deploy.

## Testes Locais

Para testar a aplicação localmente:

- **Compilar a aplicação**:
  ```bash
  sam build
  ```
  ## Invocar uma Função Localmente

Para invocar a função Lambda localmente:

```bash
sam local invoke PushNotificationFunction --event events/event.json
```

# Emular a API Localmente
Para emular a API localmente:

```bash
sam local start-api
```

# Deploy usando Terraform
Para configurar a infraestrutura com Terraform, você pode rodar os comandos diretamente no terminal ou configurar uma pipeline. Os comandos básicos são:

```bash
cd infra
terraform init
terraform validate
terraform apply
```

## Deploy Automatizado com Pipeline

Este projeto conta com uma pipeline configurada no **GitHub Actions** para automatizar o processo de deploy da função Lambda usando **Terraform**. Sempre que há um push na branch `main`, a pipeline é acionada para:

1. Fazer o checkout do código.
2. Configurar as credenciais da AWS de forma segura, usando secrets configurados no repositório.
3. Instalar o Terraform na versão especificada.
4. Inicializar o Terraform e, se necessário, destruir a versão existente da Lambda.
5. Aplicar o Terraform para criar ou atualizar a função Lambda com o código mais recente.

Com essa automação, o processo de deploy torna-se mais rápido e confiável, evitando a necessidade de execução manual dos comandos.

A configuração da pipeline está no arquivo `.github/workflows/deploy.yml` e é facilmente ajustável caso sejam necessárias alterações nos passos ou nas condições de execução.