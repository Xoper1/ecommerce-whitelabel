# E-commerce Whitelabel - Backend

API NestJS para sistema de e-commerce whitelabel com integração de múltiplos fornecedores.

## 📋 Características

- ✅ **NestJS** com TypeScript
- ✅ **Autenticação JWT**
- ✅ **Whitelabel** baseado em domínio
- ✅ **Integração com 2 fornecedores** (Brazilian e European)
- ✅ **TypeORM** com MySQL
- ✅ **Swagger** para documentação
- ✅ **Filtros de produtos** (busca, categoria, preço)

## 🚀 Tecnologias

- **Framework**: NestJS 11.x
- **Linguagem**: TypeScript
- **Banco de Dados**: MySQL (TypeORM)
- **Autenticação**: Passport JWT
- **Documentação**: Swagger/OpenAPI
- **Validação**: class-validator

## 📁 Estrutura do Projeto

```
backend/
├── src/
│   ├── auth/              # Módulo de autenticação (JWT)
│   │   ├── dto/           # DTOs de login e registro
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── auth.module.ts
│   │   └── jwt.strategy.ts
│   │
│   ├── clients/           # Módulo de clientes whitelabel
│   │   ├── client.entity.ts
│   │   ├── provider-config.entity.ts
│   │   ├── clients.controller.ts
│   │   ├── clients.service.ts
│   │   └── clients.module.ts
│   │
│   ├── users/             # Módulo de usuários
│   │   ├── user.entity.ts
│   │   ├── users.service.ts
│   │   └── users.module.ts
│   │
│   ├── providers/         # Integração com fornecedores
│   │   ├── providers.service.ts
│   │   └── providers.module.ts
│   │
│   ├── products/          # Módulo de produtos (agregação)
│   │   ├── dto/
│   │   ├── products.controller.ts
│   │   ├── products.service.ts
│   │   └── products.module.ts
│   │
│   ├── common/            # Componentes compartilhados
│   │   ├── decorators/    # @CurrentUser, @CurrentClient
│   │   ├── guards/        # JwtAuthGuard
│   │   └── middleware/    # ClientMiddleware
│   │
│   ├── database/          # Configuração do banco
│   │   └── database.module.ts
│   │
│   ├── app.module.ts
│   └── main.ts
│
├── docs/                  # Documentação
│   ├── DER.md            # Diagrama Entidade-Relacionamento
│   └── database.sql      # Script SQL
│
├── postman/              # Collection Postman
│   └── E-commerce-Whitelabel.postman_collection.json
│
├── .env.example
├── tsconfig.json
└── package.json
```

## 🛠️ Instalação

### 1. Instalar dependências

```bash
npm install
```

### 2. Configurar variáveis de ambiente

Copie o arquivo `.env.example` para `.env` e configure:

```bash
cp .env.example .env
```

Edite o arquivo `.env`:

```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=root
DB_DATABASE=ecommerce_whitelabel

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRATION=24h

# API
PORT=3000

# Providers
BRAZILIAN_PROVIDER_URL=http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/brazilian_provider
EUROPEAN_PROVIDER_URL=http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider
```

### 3. Configurar banco de dados

Execute o script SQL:

```bash
mysql -u root -p < docs/database.sql
```

Ou manualmente:

```sql
CREATE DATABASE ecommerce_whitelabel;
-- Depois execute o conteúdo de docs/database.sql
```

### 4. Configurar hosts locais (Windows)

Edite o arquivo: `C:\Windows\System32\drivers\etc\hosts`

Adicione:

```
127.0.0.1  cliente1.local
127.0.0.1  cliente2.local
127.0.0.1  cliente3.local
```

## ▶️ Executar o Projeto

### Desenvolvimento

```bash
npm run start:dev
```

### Build

```bash
npm run build
```

### Produção

```bash
npm run start
```

A API estará disponível em:
- **API**: http://localhost:3000
- **Swagger**: http://localhost:3000/api

## 📚 Documentação da API

### Swagger

Acesse: http://localhost:3000/api

### Postman

Importe a collection: `postman/E-commerce-Whitelabel.postman_collection.json`

## 🔐 Autenticação

A API usa **JWT Bearer Token**.

### Fluxo de autenticação:

1. **Register** ou **Login**:
```bash
POST /auth/login
Headers: X-Client-Domain: cliente1.local
Body: { "email": "user@cliente1.local", "password": "password123" }
```

2. Receba o `access_token`

3. Use em requisições protegidas:
```bash
GET /auth/me
Headers:
  Authorization: Bearer <token>
  X-Client-Domain: cliente1.local
```

## 🏷️ Whitelabel

### Como funciona:

1. Cliente é identificado pelo header `X-Client-Domain`
2. Middleware `ClientMiddleware` busca cliente no banco
3. Cliente é injetado em todas as rotas via `@CurrentClient()`
4. Produtos são filtrados pelos fornecedores ativos do cliente

### Exemplo:

```typescript
// Cliente 1 usa fornecedor brasileiro
GET /products
Headers: X-Client-Domain: cliente1.local
Retorna: produtos do fornecedor brasileiro

// Cliente 2 usa fornecedor europeu
GET /products
Headers: X-Client-Domain: cliente2.local
Retorna: produtos do fornecedor europeu
```

## 📡 Endpoints Principais

### Auth
- `POST /auth/register` - Registro de usuário
- `POST /auth/login` - Login
- `GET /auth/me` - Perfil do usuário autenticado (protegido)

### Clients
- `GET /clients/config` - Configuração whitelabel do cliente

### Products
- `GET /products` - Lista todos os produtos
- `GET /products/:id` - Produto por ID
- `GET /products/categories` - Categorias disponíveis

#### Filtros de produtos:
- `?search=texto` - Busca por nome/descrição
- `?category=nome` - Filtro por categoria
- `?minPrice=100` - Preço mínimo
- `?maxPrice=500` - Preço máximo

**Exemplo**:
```
GET /products?search=shirt&minPrice=50&maxPrice=200
```

## 🗄️ Banco de Dados

### Modelo de Dados

Ver diagrama completo em: `docs/DER.md`

**Tabelas**:
- `clients` - Clientes whitelabel
- `users` - Usuários de cada cliente
- `provider_configs` - Configuração de fornecedores

### Dados de Teste

O script `database.sql` já inclui dados de teste:

**Cliente 1** (Loja BR):
- Domain: `cliente1.local`
- Fornecedor: Brazilian
- Usuário: `user@cliente1.local` / `password123`

**Cliente 2** (Euro Store):
- Domain: `cliente2.local`
- Fornecedor: European
- Usuário: `user@cliente2.local` / `password123`

**Cliente 3** (Multi Store):
- Domain: `cliente3.local`
- Fornecedores: Brazilian + European
- Usuário: `user@cliente3.local` / `password123`

## 🔄 Integração com Fornecedores

### Fornecedor Brasileiro
- URL: `http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/brazilian_provider`
- Campos: `nome`, `descricao`, `preco`, `categoria`, `material`, `imagem`

### Fornecedor Europeu
- URL: `http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider`
- Campos: `name`, `description`, `price`, `gallery`, `hasDiscount`, `discountValue`

### Normalização

Ambos fornecedores são normalizados para o formato:

```typescript
{
  id: string,           // Prefixo: br_ ou eu_
  name: string,
  description: string,
  price: number,
  category: string,
  images: string[],
  material: string,
  hasDiscount: boolean,
  discountValue: number,
  provider: 'brazilian' | 'european'
}
```

## 🧪 Testando

### Com Postman

1. Importe a collection
2. Configure as variáveis:
   - `baseUrl`: http://localhost:3000
   - `client1Domain`: cliente1.local
   - `client2Domain`: cliente2.local

3. Execute: **Login - Cliente 1**
4. O token será salvo automaticamente
5. Teste os outros endpoints

### Com cURL

```bash
# Login
curl -X POST http://localhost:3000/auth/login \
  -H "X-Client-Domain: cliente1.local" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@cliente1.local","password":"password123"}'

# Listar produtos
curl http://localhost:3000/products \
  -H "X-Client-Domain: cliente1.local"
```

## 📦 Estrutura de Resposta

### Login/Register
```json
{
  "access_token": "eyJhbGc...",
  "user": {
    "id": 1,
    "email": "user@cliente1.local",
    "name": "Usuário Loja BR",
    "client": {
      "id": 1,
      "name": "Loja BR",
      "logo_url": "...",
      "primary_color": "#FF5722"
    }
  }
}
```

### Produto
```json
{
  "id": "br_1",
  "name": "Camisa Polo",
  "description": "Camisa polo de alta qualidade",
  "price": 127.00,
  "category": "Vestuário",
  "images": ["url1.jpg"],
  "material": "Algodão",
  "hasDiscount": false,
  "discountValue": 0,
  "provider": "brazilian"
}
```

## 🚨 Troubleshooting

### Erro: Client domain not found
- Verifique se o header `X-Client-Domain` está sendo enviado
- Confirme que o domínio existe no banco de dados

### Erro: Database connection
- Verifique as credenciais no `.env`
- Confirme que o MySQL está rodando
- Execute o script SQL para criar o banco

### Erro: JWT malformed
- Faça login novamente para obter novo token
- Verifique se o header Authorization está correto: `Bearer <token>`

## 📄 Licença

MIT

---

**Desenvolvido para o teste técnico Devnology**
