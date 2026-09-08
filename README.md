# 🗄️ Oficina Mecânica Infra RDS

Este repositório provisiona e opera o Amazon RDS SQL Server de `development` da Oficina Mecânica, para a Fase 3 do Tech Challenge FIAP.

## 🎯 Responsabilidades

- Consumir VPC, subnets privadas e CIDRs privados publicados pela esteira VPC.
- Criar RDS SQL Server Express, DB subnet group e security group privado.
- Publicar endpoint, security group e status no AWS Systems Manager Parameter Store.
- Controlar `apply` e `destroy` com plano e validação real na AWS.

## 🔀 Fluxo Git

```text
branch de trabalho -> PR develop -> deploy development -> PR release -> deploy homologation -> PR main -> deploy production
```

As branches protegidas são `develop`, `release`, `release/*` e `main`. A governança segue as esteiras VPC e Kubernetes:

- **🔒 Proteção Git Flow:** PR, conversas resolvidas, bloqueio de push direto/force push/deleção, sem bypass; exige os checks `🔀 01 · Validar fluxo de branches` e `🚦 03 · Quality gate`.
- **👥 Aprovação de PR:** uma aprovação, descarte de aprovação antiga e aprovação diferente do último autor do push.

## 🔁 Workflows

| Workflow | Responsabilidade |
| --- | --- |
| `🧪 CI Development` | Valida PR para `develop`, Git Flow e Terraform. |
| `🔎 CI Release` | Valida PR para `release` e `release/**`. |
| `🛡️ CI Production` | Valida PR para `main`. |
| `🚀 CD Development` | Detecta mudanças de Terraform, chama o deploy AWS e pode abrir PR para release. |
| `☁️ AWS Deploy` | Resolve `apply`/`destroy`, planeja, aplica e verifica AWS/SSM. |
| `🔀 CD Release` | Registra o deploy lógico em homologation e pode abrir PR para main. |
| `🏁 CD Production` | Registra o deploy lógico em production. |

## 🌐 Contrato entre esteiras

Conforme [RFC-0004](https://github.com/geoscabio/oficina-mecanica-api/blob/main/docs/architecture/rfcs/rfc-0004-compartilhamento-de-outputs-entre-esteiras-via-aws-systems-manager-parameter-store.md) e [ADR-0022](https://github.com/geoscabio/oficina-mecanica-api/blob/main/docs/architecture/adrs/adr-0022-uso-do-aws-systems-manager-parameter-store-para-compartilhamento-de-outputs-entre-esteiras.md), esta esteira consome:

| Parâmetro SSM | Uso |
| --- | --- |
| `/oficina-mecanica/development/status/vpc` | Deve ser `ready`. |
| `/oficina-mecanica/development/vpc/vpc_id` | VPC do RDS. |
| `/oficina-mecanica/development/vpc/private_subnet_ids` | DB subnet group. |
| `/oficina-mecanica/development/vpc/private_subnet_cidrs` | Ingress privado do SQL Server. |

Após `apply`, publica:

| Parâmetro SSM | Uso |
| --- | --- |
| `/oficina-mecanica/development/rds/endpoint` | Endpoint não secreto do RDS. |
| `/oficina-mecanica/development/rds/security_group_id` | Security group do banco. |
| `/oficina-mecanica/development/status/rds` | Marca o RDS como pronto. |

Credenciais de banco nunca são gravadas no SSM.

## 🔐 GitHub Environment

No Environment `development`, configurar os secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `DB_USERNAME` e `DB_PASSWORD`. As variables esperadas são `AWS_REGION` (padrão `us-east-1`), `AUTO_PR_ENABLED` e `RELEASE_BRANCH` (padrão `release`).

## 🧭 Controle apply/destroy

O arquivo `infra/terraform/environments/dev/terraform-action.env` controla a ação:

```env
TERRAFORM_ACTION=apply
```

Para destruir, altere-o explicitamente para `destroy` em um PR dedicado. O workflow recusa destroy se esse arquivo não mudou no mesmo push.

## 🧪 Validação local

```powershell
terraform fmt -check -recursive infra/terraform
terraform -chdir=infra/terraform/environments/dev init -backend=false
terraform -chdir=infra/terraform/environments/dev validate
```

Para gerar plano, configure credenciais AWS e as variáveis `TF_VAR_db_username` e `TF_VAR_db_password`. A ordem da Fase 3 é:

```text
infra-vpc -> infra-rds
             -> infra-kubernetes -> api
```
