# ⚡ Teste Rápido - 5 Minutos

Guia rápido para testar o sistema em 5 minutos.

## 📋 Pré-requisitos Instalados

- [x] Node.js
- [x] MySQL rodando
- [x] Dependências do backend já instaladas

## 🚀 Passo a Passo

### 1️⃣ Criar o Banco (1 min)

```bash
# Windows CMD ou PowerShell
cd C:\Users\000491631\ecommerce-whitelabel\backend
mysql -u root -p ecommerce_whitelabel < docs\database.sql

# Digite a senha do MySQL quando solicitado
```

**Senha padrão do MySQL**: geralmente é a que você definiu na instalação ou vazia.

### 2️⃣ Configurar .env (30 seg)

O arquivo `.env` já foi criado. Edite apenas se suas credenciais forem diferentes:

```bash
notepad .env
```

Verifique:
```
DB_USERNAME=root
DB_PASSWORD=root    # ← Ajuste se necessário
```

### 3️⃣ Iniciar Backend (30 seg)

```bash
# Ainda em C:\Users\000491631\ecommerce-whitelabel\backend
npm run start:dev
```

Aguarde ver:
```
🚀 Application is running on: http://localhost:3000
📚 Swagger documentation: http://localhost:3000/api
```

✅ Backend rodando!

### 4️⃣ Testar com cURL (1 min)

**Abra um NOVO terminal/PowerShell** e execute:

#### Teste 1: Listar produtos do Cliente 1 (Brasileiro)

```bash
curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"
```

**Resultado esperado**: Lista de produtos do fornecedor brasileiro (com campos `nome`, `descricao`, `preco`)

#### Teste 2: Listar produtos do Cliente 2 (Europeu)

```bash
curl http://localhost:3000/products -H "X-Client-Domain: cliente2.local"
```

**Resultado esperado**: Lista DIFERENTE de produtos do fornecedor europeu (com campos `name`, `description`, `price`, `gallery`)

#### Teste 3: Login

```bash
curl -X POST http://localhost:3000/auth/login ^
  -H "X-Client-Domain: cliente1.local" ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"user@cliente1.local\",\"password\":\"password123\"}"
```

**Resultado esperado**: JSON com `access_token` e dados do `user`

### 5️⃣ Testar com Navegador (1 min)

#### Swagger UI

1. Abra: http://localhost:3000/api
2. Clique em **GET /products**
3. Clique em **Try it out**
4. Em **Headers**, adicione:
   - Name: `X-Client-Domain`
   - Value: `cliente1.local`
5. Clique em **Execute**

✅ Deve retornar lista de produtos!

#### Produtos Diretos

Abra no navegador (produtos do Cliente 3 que usa AMBOS fornecedores):

http://localhost:3000/products

**Nota**: Pode dar erro pois não tem o header. Use Swagger ou Postman.

### 6️⃣ Testar com Postman (2 min - RECOMENDADO)

1. Abra o Postman
2. Clique em **Import**
3. Selecione: `C:\Users\000491631\ecommerce-whitelabel\backend\postman\E-commerce-Whitelabel.postman_collection.json`
4. Na collection, clique em **Login - Cliente 1**
5. Clique em **Send**

✅ Deve retornar token e salvar automaticamente!

6. Clique em **List All Products - Cliente 1**
7. Clique em **Send**

✅ Produtos do fornecedor brasileiro!

8. Clique em **List All Products - Cliente 2**
9. Clique em **Send**

✅ Produtos DIFERENTES do fornecedor europeu!

## 🎯 Testes de Funcionalidades

### ✅ Whitelabel

Verifique que clientes diferentes recebem produtos diferentes:

```bash
# Cliente 1 → Produtos brasileiros
curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"

# Cliente 2 → Produtos europeus
curl http://localhost:3000/products -H "X-Client-Domain: cliente2.local"

# Cliente 3 → TODOS os produtos (ambos fornecedores)
curl http://localhost:3000/products -H "X-Client-Domain: cliente3.local"
```

### ✅ Filtros de Produtos

#### Busca por nome

```bash
curl "http://localhost:3000/products?search=shirt" ^
  -H "X-Client-Domain: cliente1.local"
```

#### Filtro por preço

```bash
curl "http://localhost:3000/products?minPrice=100&maxPrice=500" ^
  -H "X-Client-Domain: cliente1.local"
```

#### Filtro combinado

```bash
curl "http://localhost:3000/products?search=shirt&minPrice=50&maxPrice=200" ^
  -H "X-Client-Domain: cliente1.local"
```

### ✅ Autenticação

#### Login

```bash
curl -X POST http://localhost:3000/auth/login ^
  -H "X-Client-Domain: cliente1.local" ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"user@cliente1.local\",\"password\":\"password123\"}"
```

Copie o `access_token` da resposta.

#### Perfil (com token)

```bash
curl http://localhost:3000/auth/me ^
  -H "X-Client-Domain: cliente1.local" ^
  -H "Authorization: Bearer SEU_TOKEN_AQUI"
```

## 🐛 Troubleshooting Rápido

### Erro: "Cannot connect to database"

**Solução**: MySQL não está rodando

```bash
# Inicie o MySQL (via XAMPP, Services, ou):
net start MySQL
```

### Erro: "Client domain not found"

**Solução**: Header `X-Client-Domain` não foi enviado

- Use `-H "X-Client-Domain: cliente1.local"` no cURL
- Ou adicione o header no Postman/Swagger

### Erro: "Port 3000 is already in use"

**Solução**: Outra aplicação usando a porta

```bash
# Encontre o processo
netstat -ano | findstr :3000

# Mate o processo (substitua PID)
taskkill /PID <numero_do_PID> /F
```

### Erro: "Table doesn't exist"

**Solução**: Banco não foi criado

```bash
mysql -u root -p ecommerce_whitelabel < docs\database.sql
```

## ✅ Checklist de Verificação

Após os testes, confirme:

- [ ] Backend iniciou sem erros
- [ ] Swagger acessível em http://localhost:3000/api
- [ ] Produtos listados para cliente1.local
- [ ] Produtos DIFERENTES para cliente2.local
- [ ] Login retorna access_token
- [ ] Filtros funcionando
- [ ] Postman collection importada e funcionando

## 📊 Dados de Teste

### Usuários

| Cliente | Email | Senha | Fornecedor |
|---------|-------|-------|------------|
| Cliente 1 | `user@cliente1.local` | `password123` | Brazilian |
| Cliente 2 | `user@cliente2.local` | `password123` | European |
| Cliente 3 | `user@cliente3.local` | `password123` | Both |

### Domínios

- `cliente1.local` → Loja BR (Fornecedor Brasileiro)
- `cliente2.local` → Euro Store (Fornecedor Europeu)
- `cliente3.local` → Multi Store (Ambos)

## 🎉 Pronto!

Se todos os testes passaram, o sistema está funcionando perfeitamente!

**Próximos passos:**
- Leia `README.md` para visão geral
- Leia `SETUP_INSTRUCTIONS.md` para setup completo
- Leia `PROJECT_SUMMARY.md` para detalhes técnicos
- Explore a API no Swagger: http://localhost:3000/api

---

**Tempo total**: ~5 minutos ⚡
