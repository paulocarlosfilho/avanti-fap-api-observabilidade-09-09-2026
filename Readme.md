Observabilidade
# Pipeline DevSecOps — API de Agendamento

Projeto estruturado para a Atividade Prática 1 (Scan Automático & Pipeline DevSecOps).

## Estrutura

```
.
├── .github/workflows/ci-cd.yml   # Pipeline GitHub Actions
├── api/                          # Código-fonte da API (Node/Express/TypeORM) + Dockerfile
├── observabilidade/              # Configs do Prometheus e Grafana
├── terraform/                    # IaC apontada para o LocalStack
├── docker-compose.yml            # Orquestra tudo localmente
└── README.md
```

## Como rodar localmente

1. Subir toda a stack (API, banco, LocalStack, Prometheus, Grafana):

   ```bash
   docker compose up -d --build
   ```

2. Provisionar a infraestrutura no LocalStack via Terraform:

   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```

3. Acessar:
   - API: http://localhost:3000/api/health
   - Métricas cruas: http://localhost:3000/metrics
   - Prometheus: http://localhost:9090
   - Grafana: http://localhost:3001 (login: `admin` / `admin`) — dashboard já vem pronto
   - LocalStack: http://localhost:4566 (endpoint único para todos os serviços AWS emulados)

4. Derrubar tudo:

   ```bash
   cd terraform && terraform destroy -auto-approve
   cd .. && docker compose down -v
   ```

## Como ver os arquivos no docker

1. Abrir pasta:

```bash
 docker exec -it localstack awslocal s3 ls
```

2. Listar arquivos:

```bash
docker exec -it localstack awslocal s3 ls s3://app-aponti-fap-observabilidade-s3 --recursive
```