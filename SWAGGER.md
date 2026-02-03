# 📖 Guia de Acesso à Documentação Swagger

## 🚀 Inicialização Rápida

### Passo 1: Subir os serviços
```bash
docker compose up -d
```

### Passo 2: Criar o banco de dados (primeira vez)
```bash
docker compose run --rm web bundle exec rails db:create db:migrate
```

### Passo 3: Acessar a documentação
Abra seu navegador em: **http://localhost:3000/api-docs**

## 📋 Checklist de Inicialização

- [ ] Docker e Docker Compose instalados
- [ ] Porta 3000 disponível
- [ ] Serviços rodando (`docker compose ps`)
- [ ] Banco de dados criado
- [ ] Acessar http://localhost:3000/api-docs

## 🎯 Como Usar o Swagger UI

### 1. Visualizar Endpoints

A interface mostra todos os endpoints organizados por tags:
- **Doctors** - Endpoints relacionados a médicos
- **Financial Events** - Endpoints relacionados a eventos financeiros

### 2. Testar um Endpoint

#### Exemplo: Criar um Médico

1. **Expanda** o endpoint `POST /doctors`
2. Clique no botão **"Try it out"**
3. O campo de edição mostrará um JSON de exemplo:
   ```json
   {
     "doctor": {
       "name": "Dr. Bruno",
       "crm": "123456"
     }
   }
   ```
4. **Modifique** os valores se necessário
5. Clique em **"Execute"**
6. **Veja** a resposta:
   - Status code (201 = criado com sucesso)
   - Response body com os dados do médico criado
   - Response headers

#### Exemplo: Obter Saldo de um Médico

1. **Primeiro**, crie um médico usando o endpoint acima
2. **Anote** o `id` retornado (ex: `1`)
3. **Expanda** `GET /doctors/{id}/balance`
4. Clique em **"Try it out"**
5. **Preencha** os parâmetros:
   - `id`: `1` (ou o ID do médico criado)
   - `start_date`: `2024-01-01`
   - `end_date`: `2024-01-31`
6. Clique em **"Execute"**
7. **Veja** o saldo consolidado:
   ```json
   {
     "doctor_name": "Dr. Bruno",
     "crm": "123456",
     "period": {
       "start": "2024-01-01",
       "end": "2024-01-31"
     },
     "production_total": 0.0,
     "payout_total": 0.0,
     "net_balance": 0.0
   }
   ```

#### Exemplo: Criar um Evento Financeiro

1. **Expanda** `POST /financial_events`
2. Clique em **"Try it out"**
3. **Preencha** o JSON (use o ID do médico criado anteriormente):
   ```json
   {
     "financial_event": {
       "doctor_id": 1,
       "event_type": "production",
       "amount": 5000.00,
       "date": "2024-01-15",
       "hospital": "Hospital Teste"
     }
   }
   ```
4. Clique em **"Execute"**
5. **Crie** um repasse também:
   ```json
   {
     "financial_event": {
       "doctor_id": 1,
       "event_type": "payout",
       "amount": 2000.00,
       "date": "2024-01-15",
       "hospital": "Hospital Teste"
     }
   }
   ```
6. **Teste** o endpoint de saldo novamente para ver o cálculo:
   - `production_total`: 5000.00
   - `payout_total`: 2000.00
   - `net_balance`: 3000.00

## 🔍 Recursos do Swagger UI

### Schemas
Na parte inferior da página, você pode ver os schemas de dados:
- **Doctor** - Estrutura de um médico
- **FinancialEvent** - Estrutura de um evento financeiro
- **BalanceReport** - Estrutura do relatório de saldo
- **Error** - Estrutura de erros

### Código de Exemplo
Cada endpoint mostra exemplos de código em:
- **cURL** - Para testar via terminal
- **Request URL** - URL completa da requisição
- **Response** - Exemplos de resposta

## 🐛 Problemas Comuns

### Swagger não carrega
**Solução:**
1. Verifique se o servidor está rodando:
   ```bash
   docker compose ps
   ```
2. Verifique os logs:
   ```bash
   docker compose logs web
   ```
3. Recarregue a página com **Ctrl+F5** (força recarregamento do cache)

### Erro 400 ao testar endpoints
**Causa:** Body não está sendo enviado corretamente
**Solução:**
1. Certifique-se de clicar em **"Try it out"** antes de executar
2. Verifique se o JSON está no formato correto
3. Verifique se todos os campos obrigatórios estão preenchidos

### Erro 404 no endpoint de saldo
**Causa:** Médico não existe
**Solução:**
1. Primeiro crie um médico usando `POST /doctors`
2. Use o `id` retornado no endpoint de saldo

## 📝 Notas Importantes

- A documentação Swagger é gerada automaticamente a partir do arquivo `swagger/v1/swagger.yaml`
- Os exemplos de teste são executados contra o servidor real
- Todos os dados criados via Swagger são salvos no banco de dados
- Para limpar os dados, você pode resetar o banco:
  ```bash
  docker compose run --rm web bundle exec rails db:reset
  ```

## 🔗 Links Úteis

- **Swagger UI**: http://localhost:3000/api-docs
- **Swagger YAML**: http://localhost:3000/api-docs/v1/swagger.yaml
- **API Base URL**: http://localhost:3000
