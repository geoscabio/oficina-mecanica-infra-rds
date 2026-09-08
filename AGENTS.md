# Instruções do repositório

- Trabalhe em português brasileiro e preserve UTF-8.
- Não execute `terraform apply`, `terraform destroy` ou operações AWS reais sem autorização explícita.
- Não crie branch, commit, push, merge ou PR sem autorização explícita.
- O contrato entre esteiras é o RFC-0004 e o ADR-0022 do repositório `oficina-mecanica-api`.
- Parâmetros SSM usam `/oficina-mecanica/{ambiente}/{recurso}/{output}` e status usa `/oficina-mecanica/{ambiente}/status/{recurso}`.
- Antes de destroy, valide a ausência real na AWS; `ParameterNotFound` e a exceção AWS específica de recurso inexistente são as únicas confirmações de ausência aceitas.
