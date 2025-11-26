# 🚀 COMO RODAR A APLICAÇÃO LOCALMENTE

---

## ⚠️ PRÉ-REQUISITOS

Antes de começar, você precisa ter instalado:

1. ✅ **Node.js** (você já tem: v18.16.0)
2. ✅ **npm** (você já tem: 9.5.1)
3. ❓ **MySQL 8.x** (precisa estar instalado e rodando)

---

**OU use XAMPP** 
---

## 📋 PASSO 2: CRIAR O BANCO DE DADOS

---

## 📋 PASSO 3: IMPORTAR DADOS (TABELAS + SEED)

Agora vamos popular o banco com as tabelas e dados de teste.

### Via Linha de Comando:

```cmd
# Navegue até a pasta do backend
cd C:\Users\000491631\ecommerce-whitelabel\backend

# Execute o script SQL
mysql -u root -p ecommerce_whitelabel < docs\database.sql

# Digite a senha do root

---

```
## 📋 PASSO 4: CONFIGURAR CREDENCIAIS DO BANCO
```
O arquivo `.env` já foi criado, mas precisa estar com suas credenciais corretas.

```cmd
# Abra o arquivo .env
cd C:\Users\000491631\ecommerce-whitelabel\backend
notepad .env
```

**Verifique/Edite** estas linhas conforme suas credenciais:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=SUA_SENHA_AQUI    # ← Coloque a senha do MySQL
DB_DATABASE=ecommerce_whitelabel
```

**Exemplos:**
- Se a senha do root é `root`: `DB_PASSWORD=root`
- Se a senha do root é `admin`: `DB_PASSWORD=admin`
- Se não tem senha (XAMPP padrão): `DB_PASSWORD=`

---

## 📋 PASSO 5: INICIAR O BACKEND

Agora vamos subir a aplicação!

```
cd C:\Users\000491631\ecommerce-whitelabel\backend

# Inicie o servidor de desenvolvimento
npm run start:dev
```

**O que você deve ver:**

```

🚀 Application is running on: http://localhost:3000
📚 Swagger documentation: http://localhost:3000/api
```

✅ **PRONTO! O backend está rodando!**

---

## 📋 PASSO 6: TESTAR SE ESTÁ FUNCIONANDO

### Teste 1: Abrir Swagger no navegador

Abra seu navegador e acesse:

```
http://localhost:3000/api
```

✅ Você deve ver a documentação da API (interface Swagger)

### Teste 2: Testar endpoint de produtos

Abra um **NOVO terminal/PowerShell** (deixe o servidor rodando no outro) e execute:

```cmd
curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"
```

✅ Deve retornar uma lista de produtos em JSON

### Teste 3: Testar no navegador (SEM header)

Abra: http://localhost:3000/products

❌ Deve dar erro pois não tem o header `X-Client-Domain`

Isso está correto! A API exige o header para funcionar (whitelabel).

---

## 📋 PASSO 7: TESTAR COM POSTMAN (RECOMENDADO)

### 1. Baixar Postman

Se não tiver: https://www.postman.com/downloads/

### 2. Importar a Collection

1. Abra Postman
2. Clique em **Import** (canto superior esquerdo)
3. Clique em **files**
4. Selecione o arquivo:
   ```
   C:\Users\000491631\ecommerce-whitelabel\backend\postman\E-commerce-Whitelabel.postman_collection.json
   ```
5. Clique em **Import**

### 3. Testar Login

1. Na collection importada, encontre: **Auth → Login - Cliente 1**
2. Clique nele
3. Clique em **Send**

✅ Deve retornar:
```json
{
  "access_token": "eyJhbGc...",
  "user": {
    "id": 1,
    "email": "user@cliente1.local",
    ...
  }
}
```

### 4. Testar Produtos

1. Clique em: **Products → List All Products - Cliente 1**
2. Clique em **Send**

✅ Deve retornar lista de produtos do fornecedor brasileiro

### 5. Testar Whitelabel

Compare os produtos de diferentes clientes:

- **List All Products - Cliente 1** → Produtos brasileiros
- **List All Products - Cliente 2** → Produtos europeus (DIFERENTES!)

---

## 🎯 COMANDOS ÚTEIS

### Parar o servidor

No terminal onde o servidor está rodando:
- Pressione `Ctrl + C`

### Reiniciar o servidor

```cmd
cd C:\Users\000491631\ecommerce-whitelabel\backend
npm run start:dev
```

### Ver logs em tempo real

Os logs aparecem automaticamente no terminal onde rodou `npm run start:dev`

### Verificar se a porta 3000 está em uso

```cmd
netstat -ano | findstr :3000
```

### Matar processo na porta 3000

```cmd
# Primeiro, encontre o PID
netstat -ano | findstr :3000

# Depois mate o processo (substitua <PID> pelo número)
taskkill /PID <PID> /F
```

---

## 🐛 PROBLEMAS COMUNS E SOLUÇÕES

### ❌ Erro: "Cannot connect to database"

**Causa**: MySQL não está rodando ou credenciais erradas

**Solução**:

1. **Verifique se MySQL está rodando:**
   ```cmd
   # Via XAMPP: Abra XAMPP Control Panel e clique em Start no MySQL

   # Via MySQL direto: Tente conectar
   mysql -u root -p
   ```

2. **Verifique as credenciais no `.env`:**
   ```cmd
   notepad C:\Users\000491631\ecommerce-whitelabel\backend\.env
   ```

   Confira: `DB_USERNAME`, `DB_PASSWORD`, `DB_DATABASE`

3. **Teste a conexão manualmente:**
   ```cmd
   mysql -u root -p -e "SHOW DATABASES;"
   ```

---

### ❌ Erro: "Table 'ecommerce_whitelabel.clients' doesn't exist"

**Causa**: Script SQL não foi executado

**Solução**:

```cmd
cd C:\Users\000491631\ecommerce-whitelabel\backend
mysql -u root -p ecommerce_whitelabel < docs\database.sql
```

---

### ❌ Erro: "Port 3000 is already in use"

**Causa**: Outra aplicação usando a porta 3000

**Solução 1** - Matar o processo:

```cmd
# Encontre o PID
netstat -ano | findstr :3000

# Mate (substitua 12345 pelo PID real)
taskkill /PID 12345 /F
```

**Solução 2** - Mudar a porta:

Edite o `.env`:
```env
PORT=3001
```

Reinicie o servidor.

---

### ❌ Erro: "Client domain not found"

**Causa**: Header `X-Client-Domain` não foi enviado

**Solução**:

Sempre adicione o header nas requisições:
```
X-Client-Domain: cliente1.local
```

No cURL:
```cmd
curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"
```

No Postman: O header já está configurado na collection.

---

### ❌ Warning: "Unsupported engine"

**Causa**: Você tem Node 18.16, mas NestJS 11 recomenda Node 20+

**Solução**:

⚠️ **IGNORE ESSES WARNINGS!** A aplicação vai funcionar normalmente.

Se quiser atualizar o Node (opcional):
1. Baixe Node 20+ em: https://nodejs.org
2. Instale
3. Reinicie o terminal
4. Execute `node --version` para confirmar

---

## ✅ CHECKLIST FINAL

Após seguir todos os passos:

- [ ] MySQL instalado e rodando
- [ ] Banco `ecommerce_whitelabel` criado
- [ ] Script SQL executado (3 tabelas + dados)
- [ ] Arquivo `.env` configurado com credenciais corretas
- [ ] Servidor backend rodando (`npm run start:dev`)
- [ ] Swagger acessível em http://localhost:3000/api
- [ ] Endpoint de produtos funcionando (via cURL ou Postman)
- [ ] Collection Postman importada
- [ ] Login funcionando e retornando token

---

### Próximos passos:

1. **Explore a API** via Swagger: http://localhost:3000/api
2. **Teste com Postman** todos os endpoints
3. **Leia a documentação** em:
   - `README.md` - Visão geral
   - `PROJECT_SUMMARY.md` - Detalhes técnicos
   - `backend/docs/DER.md` - Estrutura do banco

---

## 📞 RECURSOS

- **Swagger**: http://localhost:3000/api
- **Postman Collection**: `backend/postman/E-commerce-Whitelabel.postman_collection.json`
- **Documentação**: Vários arquivos `.md` na raiz do projeto

---

## 🔑 CREDENCIAIS DE TESTE

| Cliente | Email | Senha | Fornecedor |
|---------|-------|-------|------------|
| Cliente 1 | `user@cliente1.local` | `password123` | Brazilian |
| Cliente 2 | `user@cliente2.local` | `password123` | European |
| Cliente 3 | `user@cliente3.local` | `password123` | Both |

---