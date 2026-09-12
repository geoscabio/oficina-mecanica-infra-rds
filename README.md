# 🗄️ Oficina Mecânica Infra RDS

Este repositório provisiona e opera o Amazon RDS SQL Server de `development` da Oficina Mecânica, para a Fase 3 do Tech Challenge FIAP.

## 🎯 Responsabilidades

- Consumir VPC e subnets privadas publicados pela esteira VPC, e o security group do EKS publicado pela esteira Kubernetes.
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
| `/oficina-mecanica/development/status/kubernetes` | Deve ser `ready`. |
| `/oficina-mecanica/development/kubernetes/cluster_security_group_id` | Source autorizado para TCP/1433. |

Após `apply`, publica:

| Parâmetro SSM | Uso |
| --- | --- |
| `/oficina-mecanica/development/rds/endpoint` | Endpoint não secreto do RDS. |
| `/oficina-mecanica/development/rds/security_group_id` | Security group do banco. |
| `/oficina-mecanica/development/rds/master_secret_arn` | ARN não secreto do secret master gerenciado pelo RDS. |
| `/oficina-mecanica/development/status/rds` | Marca o RDS como pronto. |

O valor das credenciais de banco nunca é gravado no SSM. O RDS gera e gerencia a senha master no AWS Secrets Manager; somente o ARN não secreto é publicado para consumidores autorizados.

## 🔐 GitHub Environment

No Environment `development`, configurar os secrets `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN`. As variables esperadas são `AWS_REGION` (padrão `us-east-1`), `DB_USERNAME`, `AUTO_PR_ENABLED` e `RELEASE_BRANCH` (padrão `release`). `DB_USERNAME` não é segredo; a senha master é gerada e gerenciada pelo RDS no Secrets Manager.

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

Para gerar plano, configure credenciais AWS e a variável não secreta `TF_VAR_db_username`. O RDS gerencia a senha master no Secrets Manager. A ordem da Fase 3 é:

```text
infra-vpc -> infra-kubernetes -> infra-rds -> api
```

## ⚠️ AWS Academy

O apply do RDS com credencial master gerenciada depende de `secretsmanager:CreateSecret`, `secretsmanager:TagResource` e `kms:DescribeKey`. Essas permissões serão comprovadas somente no apply controlado; se o LabRole as bloquear, a esteira deve falhar sem fazer fallback para senha em Terraform.
