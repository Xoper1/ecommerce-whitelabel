# 🛒 E-commerce Whitelabel

Sistema completo de e-commerce whitelabel com backend NestJS e frontend Flutter.

## 📋 Sobre o Projeto

Este projeto implementa uma solução de e-commerce whitelabel que permite múltiplos clientes utilizarem a mesma plataforma com suas próprias identidades visuais (cores, logos) e fornecedores de produtos.

### Principais Características

- ✅ **Backend NestJS** com TypeORM e MySQL
- ✅ **Frontend Flutter** com Clean Architecture
- ✅ **Autenticação JWT**
- ✅ **Sistema Whitelabel** baseado em domínio
- ✅ **Integração com múltiplos fornecedores**
- ✅ **Filtros avançados** de produtos
- ✅ **Documentação completa** (Swagger + Postman)

## 🏗️ Arquitetura do Sistema

```
┌─────────────────────────────────────────────────┐
│              Flutter App (Frontend)              │
│  ┌──────────────────────────────────────────┐  │
│  │  Clean Architecture + BLoC Pattern       │  │
│  │  - Presentation Layer (UI + BLoC)        │  │
│  │  - Domain Layer (Entities + UseCases)    │  │
│  │  - Data Layer (Models + Repositories)    │  │
│  └──────────────────────────────────────────┘  │
└─────────────────┬───────────────────────────────┘
                  │ HTTP + JWT
                  ▼
┌─────────────────────────────────────────────────┐
│            NestJS API (Backend)                  │
│  ┌──────────────────────────────────────────┐  │
│  │  Modular Architecture                    │  │
│  │  - Auth Module (JWT Strategy)            │  │
│  │  - Clients Module (Whitelabel)           │  │
│  │  - Products Module (Aggregation)         │  │
│  │  - Providers Module (Integration)        │  │
│  └──────────────────────────────────────────┘  │
└─────────┬───────────────┬───────────────────────┘
          │               │
          ▼               ▼
    ┌─────────┐   ┌──────────────────┐
    │  MySQL  │   │  External APIs   │
    │Database │   │  - Brazilian     │
    │         │   │  - European      │
    └─────────┘   └──────────────────┘
```

## 📁 Estrutura do Projeto

```
ecommerce-whitelabel/
├── backend/                    # API NestJS
│   ├── src/
│   │   ├── auth/              # Autenticação JWT
│   │   ├── clients/           # Módulo de clientes whitelabel
│   │   ├── users/             # Gerenciamento de usuários
│   │   ├── products/          # Agregação de produtos
│   │   ├── providers/         # Integração com fornecedores
│   │   ├── database/          # Configuração TypeORM
│   │   └── common/            # Guards, decorators, middleware
│   ├── docs/
│   │   ├── DER.md            # Diagrama Entidade-Relacionamento
│   │   └── database.sql      # Script SQL
│   ├── postman/
│   │   └── E-commerce-Whitelabel.postman_collection.json
│   └── README.md
│
├── flutter_app/               # App Flutter
│   ├── lib/
│   │   ├── core/             # Config, Network, Theme
│   │   ├── data/             # Models, Repositories, Providers
│   │   ├── domain/           # Entities, UseCases
│   │   └── presentation/     # Pages, BLoCs, Widgets
│   └── README.md
│
└── README.md                  # Este arquivo
```

## 🚀 Quick Start

### Pré-requisitos

- **Node.js** >= 18.x
- **npm** >= 9.x
- **MySQL** >= 8.x
- **Flutter** >= 3.0
- **Dart** >= 3.0

### 1. Backend (NestJS)

```bash
# Navegar para o backend
cd backend

# Instalar dependências
npm install

# Configurar .env
cp .env.example .env
# Edite o .env com suas credenciais

# Criar banco de dados
mysql -u root -p < docs/database.sql

# Executar
npm run start:dev
```

Backend rodando em: **http://localhost:3000**
Swagger docs em: **http://localhost:3000/api**

### 2. Frontend (Flutter)

```bash
# Navegar para o Flutter
cd flutter_app

# Instalar dependências
flutter pub get

# Configurar ambiente
# Edite: lib/core/config/app_config.dart

# Executar
flutter run
```

### 3. Configurar Hosts (Windows)

Edite: `C:\Windows\System32\drivers\etc\hosts`

Adicione:
```
127.0.0.1  cliente1.local
127.0.0.1  cliente2.local
127.0.0.1  cliente3.local
```

## 🎯 Funcionalidades

### Backend

#### ✅ Autenticação
- Login com email/senha
- Registro de usuários
- JWT tokens
- Middleware de autenticação
- Perfil do usuário autenticado

#### ✅ Whitelabel
- Identificação por domínio
- Configuração personalizada (logo, cores)
- Middleware para injeção do cliente
- Filtro de fornecedores por cliente

#### ✅ Produtos
- Listagem de produtos
- Busca por nome/descrição
- Filtro por categoria
- Filtro por faixa de preço
- Detalhes do produto
- Agregação de múltiplos fornecedores
- Normalização de dados

#### ✅ Integração com Fornecedores
- Fornecedor Brasileiro (API Mock)
- Fornecedor Europeu (API Mock)
- Normalização de estruturas diferentes
- Cache de produtos (opcional)

### Frontend

#### ✅ Autenticação
- Tela de login
- Tela de registro
- Persistência de token
- Auto-login
- Logout

#### ✅ Produtos
- Lista em grid/list
- Pull-to-refresh
- Infinite scroll
- Skeleton loading
- Detalhes do produto
- Galeria de imagens

#### ✅ Filtros
- Busca por texto
- Filtro por categoria
- Filtro por preço
- Combinação de filtros

#### ✅ Whitelabel
- Tema dinâmico
- Logo do cliente
- Cores personalizadas

## 📊 Banco de Dados

### DER (Diagrama Entidade-Relacionamento)

```
┌──────────────┐       ┌─────────────────┐
│   CLIENTS    │───┬───│ PROVIDER_CONFIGS│
├──────────────┤   │   ├─────────────────┤
│ id (PK)      │   │   │ id (PK)         │
│ name         │   │   │ client_id (FK)  │
│ domain (UK)  │   │   │ provider_name   │
│ logo_url     │   │   │ is_active       │
│ primary_color│   │   │ priority        │
└──────┬───────┘   │   └─────────────────┘
       │           │
       │ 1:N       │
       │           │
┌──────▼───────┐   │
│    USERS     │   │
├──────────────┤   │
│ id (PK)      │   │
│ client_id (FK)◄──┘
│ email (UK)   │
│ password     │
│ name         │
└──────────────┘
```

Ver documentação completa em: `backend/docs/DER.md`

### Dados de Teste

**Cliente 1 - Loja BR**
- Domain: `cliente1.local`
- Fornecedor: Brazilian
- User: `user@cliente1.local` / `password123`
- Cor: `#FF5722`

**Cliente 2 - Euro Store**
- Domain: `cliente2.local`
- Fornecedor: European
- User: `user@cliente2.local` / `password123`
- Cor: `#2196F3`

**Cliente 3 - Multi Store**
- Domain: `cliente3.local`
- Fornecedores: Brazilian + European
- User: `user@cliente3.local` / `password123`
- Cor: `#4CAF50`

## 📡 API Endpoints

### Autenticação
```
POST   /auth/login        # Login
POST   /auth/register     # Registro
GET    /auth/me           # Perfil (protegido)
```

### Clientes
```
GET    /clients/config    # Configuração whitelabel
```

### Produtos
```
GET    /products                    # Lista todos
GET    /products?search=texto       # Busca
GET    /products?category=nome      # Filtra categoria
GET    /products?minPrice=100       # Filtra preço
GET    /products/:id                # Detalhes
GET    /products/categories         # Categorias
```

## 🧪 Testando

### Com Postman

1. Importe: `backend/postman/E-commerce-Whitelabel.postman_collection.json`
2. Execute "Login - Cliente 1"
3. Token é salvo automaticamente
4. Teste outros endpoints

### Com Swagger

1. Acesse: http://localhost:3000/api
2. Use "Authorize" para adicionar token
3. Teste os endpoints interativamente

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

# Filtrar produtos
curl "http://localhost:3000/products?search=shirt&minPrice=50&maxPrice=200" \
  -H "X-Client-Domain: cliente1.local"
```

## 📚 Documentação

- **Backend**: [backend/README.md](backend/README.md)
- **Flutter**: [flutter_app/README.md](flutter_app/README.md)
- **DER**: [backend/docs/DER.md](backend/docs/DER.md)
- **API**: http://localhost:3000/api (Swagger)

## 🔐 Segurança

- Senhas hashadas com bcrypt
- JWT tokens com expiração
- Headers de validação
- CORS configurado
- Validação de entrada (class-validator)
- Guards em rotas protegidas

## 🎨 Whitelabel

### Como funciona

1. **Identificação**: Cliente identificado pelo domínio (header `X-Client-Domain`)
2. **Middleware**: `ClientMiddleware` busca cliente no banco
3. **Injeção**: Cliente injetado em todas as rotas
4. **Filtro**: Produtos filtrados por fornecedores ativos
5. **Frontend**: Aplica cores e logo dinamicamente

### Exemplo

```typescript
// Cliente 1 acessa
GET /products
Headers: X-Client-Domain: cliente1.local
→ Retorna produtos do fornecedor brasileiro

// Cliente 2 acessa
GET /products
Headers: X-Client-Domain: cliente2.local
→ Retorna produtos do fornecedor europeu
```

## 🛠️ Tecnologias Utilizadas

### Backend
- **NestJS** 11.x - Framework Node.js
- **TypeORM** - ORM para MySQL
- **MySQL** - Banco de dados
- **Passport JWT** - Autenticação
- **Swagger** - Documentação
- **Axios** - HTTP client
- **bcrypt** - Hash de senhas

### Frontend
- **Flutter** 3.x - Framework mobile
- **BLoC** - State management
- **Dio** - HTTP client
- **GetIt** - Dependency injection
- **Equatable** - Value equality
- **Secure Storage** - Persistência segura

## 🚨 Troubleshooting

### Backend não inicia
- Verifique MySQL está rodando
- Confirme credenciais no `.env`
- Execute o script SQL

### Flutter não conecta
- Backend deve estar rodando
- Verifique URL em `app_config.dart`
- Android emulator: use `10.0.2.2:3000`

### Whitelabel não funciona
- Confirme header `X-Client-Domain`
- Verifique domínio no banco de dados
- Confirme hosts file configurado

## 📄 Licença

MIT

---

**Desenvolvido para o teste técnico**

**Data**: 2025
