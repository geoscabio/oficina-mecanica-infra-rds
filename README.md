# 🗄️ Oficina Mecânica Infra RDS

Este repositório cria a infraestrutura Amazon RDS da Oficina Mecânica para a Fase 3 do Tech Challenge FIAP.

## Responsabilidade

- Consome a VPC e as subnets privadas publicadas pela esteira `infra-vpc` no SSM Parameter Store.
- Cria SQL Server RDS, subnet group e security group do banco.
- Publica somente referências não secretas para as esteiras dependentes.

## Contrato entre esteiras

Segue o [RFC-0004](https://github.com/geoscabio/oficina-mecanica-api/blob/main/docs/architecture/rfcs/rfc-0004-compartilhamento-de-outputs-entre-esteiras-via-aws-systems-manager-parameter-store.md) e o [ADR-0022](https://github.com/geoscabio/oficina-mecanica-api/blob/main/docs/architecture/adrs/adr-0022-uso-do-aws-systems-manager-parameter-store-para-compartilhamento-de-outputs-entre-esteiras.md).

Consome:

- `/oficina-mecanica/development/status/vpc`
- `/oficina-mecanica/development/vpc/vpc_id`
- `/oficina-mecanica/development/vpc/private_subnet_ids`

Publica:

- `/oficina-mecanica/development/rds/endpoint`
- `/oficina-mecanica/development/rds/security_group_id`
- `/oficina-mecanica/development/status/rds`

Segredos nunca são publicados no SSM; a esteira publicará apenas o ARN do segredo quando ele for criado.
