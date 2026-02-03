# Seiwa Finance API

API Rails 7 para gerenciamento financeiro de médicos e eventos financeiros.

## 📋 Pré-requisitos

- Docker e Docker Compose instalados
- Porta 3000 disponível

## 🚀 Inicialização

### 1. Subir os serviços

```bash
docker compose up -d
```

Este comando irá:
- Iniciar o banco de dados PostgreSQL
- Iniciar o servidor Rails na porta 3000

### 2. Criar e migrar o banco de dados

```bash
docker compose run --rm web bundle exec rails db:create db:migrate
```

### 3. Acessar a documentação Swagger

Abra seu navegador e acesse:

**http://localhost:3000/api-docs**

A interface Swagger UI permitirá:
- Visualizar todos os endpoints da API
- Testar os endpoints diretamente na interface
- Ver exemplos de requisições e respostas

## 📚 Endpoints Disponíveis

### Doctors

- `POST /doctors` - Criar um médico
- `GET /doctors/:id/balance` - Obter saldo consolidado de um médico

### Financial Events

- `POST /financial_events` - Criar um evento financeiro (produção ou repasse)

## 🧪 Rodar os Testes

```bash
# Criar banco de teste (primeira vez)
docker compose run --rm -e RAILS_ENV=test -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web bundle exec rails db:create db:migrate

# Rodar todos os testes
docker compose run --rm -e RAILS_ENV=test -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web bundle exec rspec

# Rodar um arquivo específico
docker compose run --rm -e RAILS_ENV=test -e DISABLE_DATABASE_ENVIRONMENT_CHECK=1 web bundle exec rspec spec/requests/doctors_spec.rb
```

## 📖 Documentação Swagger

### Acessar a Documentação

1. Certifique-se de que o servidor está rodando:
   ```bash
   docker compose up -d
   ```

2. Acesse no navegador:
   ```
   http://localhost:3000/api-docs
   ```

### Testar Endpoints no Swagger

1. Na interface Swagger, expanda o endpoint desejado
2. Clique em **"Try it out"**
3. Preencha os parâmetros necessários
4. Clique em **"Execute"**
5. Veja a resposta do servidor

### Exemplo: Criar um Médico

1. Expanda `POST /doctors`
2. Clique em **"Try it out"**
3. No campo de edição, você verá um JSON de exemplo:
   ```json
   {
     "doctor": {
       "name": "Dr. Bruno",
       "crm": "123456"
     }
   }
   ```
4. Modifique os valores se necessário
5. Clique em **"Execute"**
6. Veja a resposta com o médico criado

### Exemplo: Obter Saldo de um Médico

1. Primeiro, crie um médico usando o endpoint acima
2. Anote o `id` retornado na resposta
3. Expanda `GET /doctors/{id}/balance`
4. Clique em **"Try it out"**
5. Preencha:
   - `id`: O ID do médico criado
   - `start_date`: Data inicial (ex: `2024-01-01`)
   - `end_date`: Data final (ex: `2024-01-31`)
6. Clique em **"Execute"**
7. Veja o saldo consolidado

## 🔧 Comandos Úteis

### Ver logs do servidor
```bash
docker compose logs -f web
```

### Parar os serviços
```bash
docker compose down
```

### Reconstruir os containers
```bash
docker compose down
docker compose build
docker compose up -d
```

### Acessar o console Rails
```bash
docker compose run --rm web bundle exec rails console
```

### Ver rotas disponíveis
```bash
docker compose run --rm web bundle exec rails routes
```

## 📝 Estrutura do Projeto

```
seiwa-finance-api/
├── app/
│   ├── controllers/
│   │   ├── doctors_controller.rb
│   │   ├── financial_events_controller.rb
│   │   └── swagger_controller.rb
│   ├── models/
│   │   ├── doctor.rb
│   │   └── financial_event.rb
│   └── serializers/
├── config/
│   └── routes.rb
├── db/
│   └── migrate/
├── spec/
│   ├── requests/
│   ├── swagger/
│   └── factories/
└── swagger/
    └── v1/
        └── swagger.yaml
```

## 🐛 Troubleshooting

### Erro: "Port already in use"
Se a porta 3000 estiver em uso, você pode alterar no `docker-compose.yml`:
```yaml
ports:
  - "3001:3000"  # Mude 3000 para outra porta
```

### Erro: "Database does not exist"
Execute novamente:
```bash
docker compose run --rm web bundle exec rails db:create db:migrate
```

### Swagger não carrega
1. Verifique se o servidor está rodando: `docker compose ps`
2. Verifique os logs: `docker compose logs web`
3. Recarregue a página com Ctrl+F5 (força recarregamento)

## 📄 Licença

Este projeto é privado e de uso interno.
