# 🗄️ Oficina Mecânica — Infraestrutura RDS

Banco SQL Server privado da solução Oficina Mecânica. A visão de entrada está no
[README da API](https://github.com/geoscabio/oficina-mecanica-api#readme).

---

## 📌 Índice

- [✨ Visão geral](#visao-geral)
- [🏗️ Responsabilidade e fluxo](#arquitetura)
- [🧩 Repositórios da solução](#repositorios)
- [🔐 Pré-requisitos e configuração](#configuracao)
- [☁️ Execução, CI/CD e deploy](#deploy)

---

<a id="visao-geral"></a>

## ✨ Visão geral

Camada de dados privada, com segredo mestre gerenciado fora do código.

<a id="arquitetura"></a>

## 🏗️ Responsabilidade e fluxo

Este repositório provisiona o RDS, grupo de segurança, Secret do administrador
no AWS Secrets Manager e contratos SSM. O banco permanece em sub-redes privadas.

`VPC privada -> RDS SQL Server <- API, Auth Lambda e workloads autorizados`

---

<a id="repositorios"></a>

## 🧩 Repositórios da solução

| Repositório | Responsabilidade |
|---|---|
| [API](https://github.com/geoscabio/oficina-mecanica-api) | Aplicação .NET e documentação principal. |
| [Auth Lambda](https://github.com/geoscabio/oficina-mecanica-auth-lambda) | Autenticação por documento. |
| [VPC](https://github.com/geoscabio/oficina-mecanica-infra-vpc) | Rede base. |
| [Kubernetes](https://github.com/geoscabio/oficina-mecanica-infra-kubernetes) | EKS e identidade de acesso dos workloads. |
| [RDS](https://github.com/geoscabio/oficina-mecanica-infra-rds) | SQL Server, security group e segredo mestre. |
| [API Gateway](https://github.com/geoscabio/oficina-mecanica-infra-api-gateway) | Entrada HTTP. |

---

<a id="configuracao"></a>

## 🔐 Pré-requisitos e configuração

Terraform, AWS CLI e os contratos da VPC são necessários. O cluster Kubernetes
deve estar aplicado antes do RDS quando o workflow exigir seu security group.

| Nome | Tipo e escopo | Obrigatório | Finalidade |
|---|---|---:|---|
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | GitHub Environment Secrets (`development`) | Sim | Credenciais AWS. |
| `AWS_SESSION_TOKEN` | GitHub Environment Secret (`development`) | Quando temporário | Sessão AWS. |
| `AWS_REGION` | GitHub Variable | Sim | Região AWS. |
| `DB_USERNAME` | GitHub Variable | Sim | Usuário mestre inicial do RDS. |
| `AUTO_PR_ENABLED`, `RELEASE_BRANCH` | GitHub Variables | Não | Promoção. |
| Credencial mestre | AWS Secrets Manager, conta AWS | Gerada pelo Terraform | Senha não versionada; apenas o ARN é publicado. |

Consome `/oficina-mecanica/development/status/vpc`, `/vpc/vpc_id`,
`/vpc/private_subnet_ids`, `/status/kubernetes` e
`/kubernetes/cluster_security_group_id`. Publica `/rds/endpoint`,
`/rds/security_group_id`, `/rds/master_secret_arn` e
`/oficina-mecanica/development/status/rds`.

---

<a id="deploy"></a>

## ☁️ Execução, CI/CD e deploy

O `aws-deploy.yml` mantém as ações existentes de plan/apply/destroy. No diretório
Terraform:

```powershell
terraform fmt -check
terraform validate
terraform plan
```

Use o endpoint e o ARN publicados em SSM; não copie a senha para `tfvars`, código
ou GitHub Secrets. Métricas e logs são nativos AWS neste repositório; Datadog não
é configurado aqui. Valide também `git diff --check` e os checks do workflow.

Documentação: [API principal](https://github.com/geoscabio/oficina-mecanica-api#readme),
[Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/) e
[AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/).
