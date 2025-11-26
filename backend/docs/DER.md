# Diagrama Entidade-Relacionamento (DER)

## Diagrama Visual

```
┌─────────────────────────────────┐
│          CLIENTS                │
├─────────────────────────────────┤
│ PK  id (INT)                    │
│     name (VARCHAR)              │
│ UK  domain (VARCHAR)            │
│     logo_url (VARCHAR)          │
│     primary_color (VARCHAR)     │
│     created_at (TIMESTAMP)      │
└────────┬────────────────────────┘
         │
         │ 1:N
         │
    ┌────┴─────────────────────────┐
    │                              │
    │                              │
┌───▼──────────────────┐  ┌────▼──────────────────────┐
│      USERS           │  │   PROVIDER_CONFIGS        │
├──────────────────────┤  ├───────────────────────────┤
│ PK  id (INT)         │  │ PK  id (INT)              │
│ FK  client_id (INT)  │  │ FK  client_id (INT)       │
│ UK  email (VARCHAR)  │  │     provider_name (VARCHAR)│
│     password (VARCHAR)│  │     is_active (BOOLEAN)   │
│     name (VARCHAR)   │  │     priority (INT)        │
│     created_at (TS)  │  └───────────────────────────┘
└──────────────────────┘
```

## Relacionamentos

### 1. CLIENTS (Tabela Principal)
- **Descrição**: Armazena informações de cada cliente whitelabel
- **Campos**:
  - `id`: Identificador único do cliente
  - `name`: Nome do cliente
  - `domain`: Domínio único do cliente (ex: cliente1.local)
  - `logo_url`: URL do logotipo do cliente
  - `primary_color`: Cor primária do tema (hex)
  - `created_at`: Data de criação

**Índices**:
- PRIMARY KEY: `id`
- UNIQUE: `domain`

---

### 2. USERS
- **Descrição**: Usuários pertencentes a cada cliente
- **Campos**:
  - `id`: Identificador único do usuário
  - `client_id`: Referência ao cliente (FK)
  - `email`: Email único do usuário
  - `password`: Senha hash (bcrypt)
  - `name`: Nome completo
  - `created_at`: Data de criação

**Relacionamentos**:
- `client_id` → `CLIENTS.id` (N:1)
  - Um cliente pode ter vários usuários
  - Um usuário pertence a um único cliente
  - ON DELETE CASCADE

**Índices**:
- PRIMARY KEY: `id`
- UNIQUE: `email`
- INDEX: `client_id`

---

### 3. PROVIDER_CONFIGS
- **Descrição**: Configuração de fornecedores ativos para cada cliente
- **Campos**:
  - `id`: Identificador único
  - `client_id`: Referência ao cliente (FK)
  - `provider_name`: Nome do fornecedor ('brazilian' ou 'european')
  - `is_active`: Se o fornecedor está ativo
  - `priority`: Ordem de prioridade (menor = maior prioridade)

**Relacionamentos**:
- `client_id` → `CLIENTS.id` (N:1)
  - Um cliente pode ter múltiplos fornecedores
  - Um fornecedor config pertence a um cliente
  - ON DELETE CASCADE

**Índices**:
- PRIMARY KEY: `id`
- INDEX: `client_id, is_active`

---

## Cardinalidade

```
CLIENTS (1) ──────────── (N) USERS
  │
  └──── (1) ──────────── (N) PROVIDER_CONFIGS
```

- Um **CLIENTE** pode ter **vários USUÁRIOS**
- Um **CLIENTE** pode ter **várias CONFIGURAÇÕES DE FORNECEDOR**
- Um **USUÁRIO** pertence a **um único CLIENTE**
- Uma **CONFIGURAÇÃO** pertence a **um único CLIENTE**

---

## Lógica de Negócio

### Whitelabel
1. Cada cliente é identificado pelo campo `domain`
2. O middleware detecta o domínio da requisição
3. Busca o cliente correspondente no banco
4. Todas as operações são filtradas por `client_id`

### Autenticação
1. Usuário faz login com email/senha
2. Sistema valida credenciais
3. Retorna JWT com `client_id` no payload
4. Todas requisições subsequentes incluem o cliente

### Fornecedores
1. Cada cliente pode configurar quais fornecedores usar
2. Campo `is_active` controla se está habilitado
3. Campo `priority` define ordem de busca
4. API agrega produtos apenas de fornecedores ativos

---

## Exemplos de Queries

### Buscar cliente por domínio
```sql
SELECT * FROM clients WHERE domain = 'cliente1.local';
```

### Buscar usuários de um cliente
```sql
SELECT u.* FROM users u
WHERE u.client_id = 1;
```

### Buscar fornecedores ativos de um cliente
```sql
SELECT * FROM provider_configs
WHERE client_id = 1 AND is_active = TRUE
ORDER BY priority ASC;
```

### Login de usuário
```sql
SELECT u.*, c.name as client_name, c.logo_url, c.primary_color
FROM users u
JOIN clients c ON u.client_id = c.id
WHERE u.email = 'user@cliente1.local';
```
