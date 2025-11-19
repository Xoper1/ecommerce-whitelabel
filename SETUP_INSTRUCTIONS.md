# 🚀 Instruções de Setup - E-commerce Whitelabel

Guia completo para configurar e executar o projeto.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **Node.js** versão 18.x ou superior
- **npm** versão 9.x ou superior
- **MySQL** versão 8.x ou superior
- **Flutter** versão 3.0 ou superior (opcional, para o app mobile)
- **Git** (para clonar o repositório)

## 🗄️ Passo 1: Configurar o Banco de Dados

### 1.1. Instalar MySQL

Se ainda não tiver MySQL instalado:
- **Windows**: https://dev.mysql.com/downloads/installer/
- **macOS**: `brew install mysql`
- **Linux**: `sudo apt-get install mysql-server`

### 1.2. Iniciar o MySQL

```bash
# Windows (via Services ou XAMPP)
# macOS/Linux
sudo mysql.server start
# ou
sudo service mysql start
```

### 1.3. Criar o Banco de Dados

```bash
# Entrar no MySQL
mysql -u root -p

# Criar banco (ou execute o script SQL direto)
CREATE DATABASE ecommerce_whitelabel;
exit;
```

### 1.4. Executar o Script SQL

```bash
cd ecommerce-whitelabel/backend
mysql -u root -p ecommerce_whitelabel < docs/database.sql
```

**Ou** copie e cole o conteúdo de `backend/docs/database.sql` no MySQL Workbench.

Isso criará:
- ✅ Tabelas: `clients`, `users`, `provider_configs`
- ✅ 3 clientes de teste (Loja BR, Euro Store, Multi Store)
- ✅ Usuários de teste com senha `password123`

## ⚙️ Passo 2: Configurar o Backend (NestJS)

### 2.1. Navegar para o backend

```bash
cd ecommerce-whitelabel/backend
```

### 2.2. Instalar dependências

```bash
npm install
```

**Nota**: Pode levar alguns minutos. Ignore warnings sobre versão do Node se estiver usando Node 18.

### 2.3. Configurar variáveis de ambiente

O arquivo `.env` já foi criado a partir do `.env.example`. Edite-o se necessário:

```bash
# Windows
notepad .env

# macOS/Linux
nano .env
```

Verifique/edite as configurações:

```env
# Database - Ajuste conforme suas credenciais
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=root
DB_DATABASE=ecommerce_whitelabel

# JWT - Pode manter ou alterar
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRATION=24h

# API
PORT=3000

# Providers (NÃO ALTERAR)
BRAZILIAN_PROVIDER_URL=http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/brazilian_provider
EUROPEAN_PROVIDER_URL=http://616d6bdb6dacbb001794ca17.mockapi.io/devnology/european_provider
```

### 2.4. Iniciar o backend

```bash
npm run start:dev
```

Você deve ver:

```
🚀 Application is running on: http://localhost:3000
📚 Swagger documentation: http://localhost:3000/api
```

✅ **Backend está rodando!**

### 2.5. Testar a API

Abra o navegador:
- **Swagger UI**: http://localhost:3000/api

Ou use cURL:

```bash
curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"
```

## 🌐 Passo 3: Configurar DNS Local (Whitelabel)

Para testar o whitelabel com diferentes domínios:

### Windows

1. Abra o Bloco de Notas como **Administrador**
2. Abra o arquivo: `C:\Windows\System32\drivers\etc\hosts`
3. Adicione no final:

```
127.0.0.1  cliente1.local
127.0.0.1  cliente2.local
127.0.0.1  cliente3.local
```

4. Salve o arquivo

### macOS/Linux

```bash
sudo nano /etc/hosts
```

Adicione:
```
127.0.0.1  cliente1.local
127.0.0.1  cliente2.local
127.0.0.1  cliente3.local
```

Salve com `Ctrl+O`, `Enter`, `Ctrl+X`

### Verificar

```bash
ping cliente1.local
# Deve responder de 127.0.0.1
```

## 📱 Passo 4: Configurar o Flutter (Opcional)

### 4.1. Verificar instalação do Flutter

```bash
flutter doctor
```

Se não tiver Flutter instalado: https://flutter.dev/docs/get-started/install

### 4.2. Navegar para o app

```bash
cd ecommerce-whitelabel/flutter_app
```

### 4.3. Instalar dependências

```bash
flutter pub get
```

### 4.4. Configurar ambiente

Edite `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Para Android Emulator, use: http://10.0.2.2:3000
  // Para iOS Simulator/Desktop, use: http://localhost:3000
  static const String baseUrl = 'http://localhost:3000';

  // Cliente a ser utilizado
  static const String clientDomain = 'cliente1.local';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
```

### 4.5. Executar o app

```bash
# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Android (com emulator aberto)
flutter run -d android

# iOS (macOS only, com simulator aberto)
flutter run -d ios
```

**Nota**: O app Flutter está com estrutura base. Para implementação completa, siga `flutter_app/IMPLEMENTATION_GUIDE.md`

## 🧪 Passo 5: Testar a Aplicação

### 5.1. Testar com Postman

1. Abra o Postman
2. Importe a collection: `backend/postman/E-commerce-Whitelabel.postman_collection.json`
3. Configure as variáveis:
   - `baseUrl`: http://localhost:3000
   - `client1Domain`: cliente1.local
   - `client2Domain`: cliente2.local

4. Execute **Login - Cliente 1**
   - Deve retornar um `access_token`
   - Token é salvo automaticamente

5. Execute **List All Products - Cliente 1**
   - Deve retornar produtos do fornecedor brasileiro

6. Execute **List All Products - Cliente 2**
   - Deve retornar produtos do fornecedor europeu

### 5.2. Testar Filtros

Execute no Postman:
- **Search Products**: Busca por "shirt"
- **Filter by Category**: Filtra por "Fantastic"
- **Filter by Price Range**: min=100, max=500
- **Combined Filters**: search + preço

### 5.3. Testar Whitelabel

Compare as respostas:

```bash
# Cliente 1 (Loja BR - Fornecedor Brasileiro)
curl http://localhost:3000/products \
  -H "X-Client-Domain: cliente1.local"

# Cliente 2 (Euro Store - Fornecedor Europeu)
curl http://localhost:3000/products \
  -H "X-Client-Domain: cliente2.local"

# Cliente 3 (Multi Store - AMBOS fornecedores)
curl http://localhost:3000/products \
  -H "X-Client-Domain: cliente3.local"
```

Os produtos retornados devem ser diferentes!

### 5.4. Credenciais de Teste

| Cliente | Email | Senha | Fornecedor |
|---------|-------|-------|------------|
| Loja BR | `user@cliente1.local` | `password123` | Brazilian |
| Euro Store | `user@cliente2.local` | `password123` | European |
| Multi Store | `user@cliente3.local` | `password123` | Both |

## 📚 Documentação

Após iniciar o backend, acesse:

- **Swagger UI**: http://localhost:3000/api
  - Documentação interativa de todos os endpoints
  - Teste direto na interface
  - Exportação de especificação OpenAPI

- **Postman Collection**: `backend/postman/E-commerce-Whitelabel.postman_collection.json`
  - Collection completa com todos os endpoints
  - Variáveis configuradas
  - Scripts para auto-save do token

- **DER**: `backend/docs/DER.md`
  - Diagrama Entidade-Relacionamento
  - Explicação das tabelas
  - Exemplos de queries

## 🚨 Troubleshooting

### Erro: "Cannot connect to database"

**Causa**: MySQL não está rodando ou credenciais incorretas

**Solução**:
```bash
# Verificar se MySQL está rodando
sudo service mysql status

# Iniciar MySQL
sudo service mysql start

# Verificar credenciais no .env
nano backend/.env
```

### Erro: "Client domain not found"

**Causa**: Header `X-Client-Domain` não está sendo enviado ou domínio não existe

**Solução**:
- Sempre envie o header: `X-Client-Domain: cliente1.local`
- Verifique se os dados foram inseridos no banco (execute o script SQL)

### Erro: "Port 3000 is already in use"

**Causa**: Outra aplicação usando a porta 3000

**Solução**:
```bash
# Encontrar processo usando a porta
# Windows
netstat -ano | findstr :3000

# macOS/Linux
lsof -i :3000

# Matar o processo
kill -9 <PID>

# OU alterar a porta no .env
PORT=3001
```

### Erro: "Module not found" no NestJS

**Causa**: Dependências não instaladas

**Solução**:
```bash
cd backend
rm -rf node_modules
npm install
```

### Erro: Flutter não encontra o backend

**Causa**: URL incorreta em `app_config.dart`

**Solução**:
- **Desktop/Web**: `http://localhost:3000`
- **Android Emulator**: `http://10.0.2.2:3000`
- **iOS Simulator**: `http://localhost:3000`
- **Dispositivo físico**: `http://<SEU_IP_LOCAL>:3000`

## 📊 Verificação Final

Execute o checklist:

### Backend
- [ ] MySQL rodando
- [ ] Banco criado e populado
- [ ] `.env` configurado
- [ ] `npm install` executado
- [ ] Backend rodando em http://localhost:3000
- [ ] Swagger acessível em http://localhost:3000/api
- [ ] Login funcionando no Postman
- [ ] Produtos sendo listados

### Flutter (Opcional)
- [ ] Flutter instalado (`flutter doctor`)
- [ ] Dependências instaladas (`flutter pub get`)
- [ ] `app_config.dart` configurado com URL correta
- [ ] App rodando no dispositivo/emulador

### Whitelabel
- [ ] Hosts file configurado
- [ ] Ping para cliente1.local funciona
- [ ] Produtos diferentes para cliente1 vs cliente2

## 🎯 Próximos Passos

Após tudo configurado:

1. **Explore a API** via Swagger: http://localhost:3000/api
2. **Teste todos os endpoints** com Postman
3. **Leia a documentação** em cada pasta README.md
4. **Implemente features no Flutter** seguindo `flutter_app/IMPLEMENTATION_GUIDE.md`
5. **Customize** cores, logos e fornecedores para seus clientes

## 💡 Dicas

- Use **Postman** para desenvolvimento rápido da API
- Use **Swagger** para documentação e exploração
- Consulte os **README.md** em cada pasta para detalhes
- Os **dados de teste** já estão no banco (script SQL)
- **Logs** do backend ajudam a debugar (aparecem no console)

## 📞 Recursos Adicionais

- **NestJS Docs**: https://docs.nestjs.com
- **Flutter Docs**: https://flutter.dev/docs
- **TypeORM Docs**: https://typeorm.io
- **BLoC Pattern**: https://bloclibrary.dev

---

**Projeto criado para o teste técnico Devnology**

Boa sorte! 🚀
