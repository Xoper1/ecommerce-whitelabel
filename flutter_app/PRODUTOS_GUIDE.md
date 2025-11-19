# Guia: Como Buscar Produtos - E-commerce Whitelabel

## Estrutura Criada

Implementamos um sistema completo de busca de produtos seguindo a arquitetura Clean Architecture:

```
lib/
├── data/
│   ├── models/
│   │   └── product_model.dart          ← Modelo de dados da API
│   ├── providers/
│   │   └── product_provider.dart       ← Comunicação com API
│   └── repositories/
│       └── product_repository.dart     ← Interface entre dados e domínio
├── domain/
│   ├── entities/
│   │   └── product_entity.dart         ← Entidade de negócio
│   └── usecases/
│       └── product_usecases.dart       ← Casos de uso
├── presentation/
│   └── products/
│       ├── blocs/
│       │   └── product_bloc.dart       ← Gerenciamento de estado
│       └── pages/
│           └── products_list_page.dart ← UI de produtos
└── core/
    └── di/
        └── service_locator.dart        ← Injeção de dependências
```

## Fluxo de Dados

```
HomePage
    ↓
[Botão "Ver Produtos"]
    ↓
ProductsListPage (Tela de listagem)
    ↓
ProductBloc (Gerencia estado)
    ↓
GetProductsUseCase (Regra de negócio)
    ↓
ProductRepository (Abstração de dados)
    ↓
ProductProvider (Chamadas HTTP via Dio)
    ↓
API Backend (GET /products)
```

## Como Usar

### 1. Na HomePage
```dart
ElevatedButton.icon(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ServiceLocator.getProductBloc(),
          child: const ProductsListPage(),
        ),
      ),
    );
  },
  icon: const Icon(Icons.shopping_bag),
  label: const Text('Ver Produtos'),
)
```

### 2. A ProductsListPage oferece:
- **Busca por nome**: Campo de texto para filtrar produtos
- **Filtro por categoria**: Chips para selecionar categorias
- **Grid de produtos**: Exibição em 2 colunas
- **Card de produto**: Mostra imagem, nome, categoria e preço

### 3. Dados Exibidos por Produto:
- Imagem
- Nome
- Categoria
- Preço original
- Preço com desconto (se houver)
- Badge de desconto (%)

## Endpoints da API Utilizados

### Listar Produtos
```
GET /products?search=termo&category=cat&minPrice=100&maxPrice=500
```

**Parâmetros opcionais:**
- `search` - busca por nome/descrição
- `category` - filtro por categoria
- `minPrice` - preço mínimo
- `maxPrice` - preço máximo

**Resposta:**
```json
[
  {
    "id": "br_1",
    "name": "Camisa Polo",
    "description": "Descrição...",
    "price": 127.00,
    "category": "Vestuário",
    "images": ["url1.jpg"],
    "material": "Algodão",
    "hasDiscount": true,
    "discountValue": 27.00,
    "provider": "brazilian"
  }
]
```

### Buscar Categorias
```
GET /products/categories
```

**Resposta:**
```json
["Vestuário", "Acessórios", "Calçados", ...]
```

## Requisitos Necessários para Funcionar

### 1. Backend Rodando
```bash
cd backend
npm run start:dev
```

### 2. Banco de Dados Configurado
- MySQL rodando
- Database `ecommerce_whitelabel` criado
- Script `docs/database.sql` executado

### 3. Variáveis de Ambiente `.env`
```env
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=root
DB_DATABASE=ecommerce_whitelabel
JWT_SECRET=your-secret-key
PORT=3000
```

### 4. Cliente Configurado
- Header `X-Client-Domain` enviado automaticamente
- Cliente deve existir no banco de dados

## Testando Localmente

### Opção 1: Com Postman
1. Importe a collection: `backend/postman/E-commerce-Whitelabel.postman_collection.json`
2. Faça login para pegar o token
3. Teste `/products`

### Opção 2: Com cURL
```bash
curl http://localhost:3000/products \
  -H "X-Client-Domain: cliente1.local"
```

### Opção 3: No Flutter Web
1. Verifique se `ApiClient` está configurado com `baseUrl` correto
2. Configure o domínio correto em `AppConfig.clientDomain`
3. Clique em "Ver Produtos" na HomePage

## Tratamento de Erros

O sistema trata automaticamente:
- **Rede indisponível**: Exibe mensagem de erro com botão "Tentar Novamente"
- **Backend fora**: Mostra erro da API
- **Sem produtos**: Exibe "Nenhum produto encontrado"

## Próximas Melhorias

1. **Paginação**: Adicionar scroll infinito ou botão de carregar mais
2. **Filtros avançados**: Intervalo de preço com slider
3. **Ordenação**: Ordernar por preço, popularidade, etc
4. **Página de detalhes**: Clicar em produto leva aos detalhes
5. **Carrinho de compras**: Adicionar produtos ao carrinho
6. **Favoritos**: Marcar produtos como favoritos
7. **Imagens múltiplas**: Galeria de imagens por produto
8. **Avaliações**: Mostrar rating de produtos

## Debugging

Se a listagem de produtos não aparecer:

1. **Verifique se backend está rodando:**
   ```bash
   curl http://localhost:3000/products -H "X-Client-Domain: cliente1.local"
   ```

2. **Verifique logs do Flutter:**
   - Abra DevTools (F12 no Chrome)
   - Procure por mensagens de erro de rede

3. **Configure `AppConfig`:**
   - Verifique `baseUrl` em `lib/core/config/app_config.dart`
   - Deve apontar para `http://localhost:3000`

4. **Teste com dados simulados:**
   - Edite `ProductProvider` para retornar dados hardcoded

## Arquivos Modificados/Criados

✅ `lib/data/models/product_model.dart` - Modelo com parse de JSON flexível
✅ `lib/data/providers/product_provider.dart` - Provider com métodos de API
✅ `lib/data/repositories/product_repository.dart` - Repository com interface
✅ `lib/domain/entities/product_entity.dart` - Entity melhorada com cálculos
✅ `lib/domain/usecases/product_usecases.dart` - UseCases de produtos
✅ `lib/presentation/products/blocs/product_bloc.dart` - BLoC de estado
✅ `lib/presentation/products/pages/products_list_page.dart` - Página completa
✅ `lib/core/di/service_locator.dart` - Injeção de dependências
✅ `lib/main.dart` - HomePage com botão para produtos

## Resumo

Agora você tem uma forma completa de buscar e exibir produtos:

1. **Clique em "Ver Produtos"** na HomePage
2. **A aplicação busca produtos** da API backend
3. **Exibe em grid** com todas as informações
4. **Permite filtrar** por busca e categoria
5. **Tudo com tratamento de erro** e estados de carregamento

Basta que o backend esteja rodando e o banco de dados configurado!
