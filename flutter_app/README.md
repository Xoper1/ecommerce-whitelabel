# E-commerce Whitelabel - Flutter App

Aplicativo Flutter para e-commerce whitelabel seguindo Clean Architecture.

## 📋 Características

- ✅ **Clean Architecture** (Domain, Data, Presentation)
- ✅ **BLoC** para gerenciamento de estado
- ✅ **Autenticação JWT**
- ✅ **Whitelabel** dinâmico
- ✅ **Listagem e filtros** de produtos
- ✅ **Persistência** de sessão

## 🏗️ Arquitetura

### Clean Architecture

```
lib/
├── core/                  # Configurações e utilitários
│   ├── config/           # Configurações do app
│   ├── network/          # Cliente HTTP (Dio)
│   └── theme/            # Temas dinâmicos
│
├── data/                 # Camada de Dados
│   ├── models/          # Modelos (JSON <-> Entity)
│   ├── providers/       # Data providers (API calls)
│   └── repositories/    # Implementação de repositórios
│
├── domain/              # Camada de Domínio
│   ├── entities/       # Entidades de negócio
│   └── usecases/       # Casos de uso
│
└── presentation/        # Camada de Apresentação
    ├── auth/           # Autenticação
    │   ├── pages/      # Telas de login/registro
    │   └── blocs/      # BLoC de auth
    │
    ├── products/       # Produtos
    │   ├── pages/      # Lista e detalhes
    │   └── blocs/      # BLoC de produtos
    │
    └── shared/         # Widgets compartilhados
        └── widgets/
```

### Fluxo de Dados

```
[UI (Widget)]
    ↓ eventos
[BLoC]
    ↓ chama
[UseCase]
    ↓ usa
[Repository (interface)]
    ↓ implementado por
[Repository Impl]
    ↓ usa
[Data Provider (API)]
    ↓ retorna
[Model]
    ↓ converte
[Entity]
    ↓ retorna para
[BLoC]
    ↓ emite estados
[UI (Widget)]
```

## 📦 Dependências Principais

```yaml
# State Management
flutter_bloc: ^8.1.3      # BLoC pattern
equatable: ^2.0.5         # Value equality

# Dependency Injection
get_it: ^7.6.4           # Service locator

# HTTP
dio: ^5.3.3              # HTTP client

# Storage
shared_preferences: ^2.2.2
flutter_secure_storage: ^9.0.0

# UI
cached_network_image: ^3.3.0
shimmer: ^3.0.0
```

## 🚀 Como Executar

### 1. Instalar Flutter

- Baixe e instale: https://flutter.dev/docs/get-started/install

### 2. Verificar instalação

```bash
flutter doctor
```

### 3. Instalar dependências

```bash
cd flutter_app
flutter pub get
```

### 4. Configurar ambiente

Edite `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String clientDomain = 'cliente1.local';
}
```

### 5. Executar

```bash
# Desenvolvimento
flutter run

# Dispositivos específicos
flutter run -d chrome        # Web
flutter run -d windows       # Windows
flutter run -d android       # Android
flutter run -d ios           # iOS
```

## 📱 Funcionalidades Implementadas

### Autenticação

#### Login
- Tela de login com email/senha
- Validação de campos
- Loading state
- Erro handling
- Persistência de token
- Auto-login se token válido

#### Registro
- Formulário de registro
- Validação de email/senha
- Criação de conta

#### Logout
- Limpar token e dados do usuário
- Redirecionar para login

### Produtos

#### Lista de Produtos
- Grid/List view
- Pull-to-refresh
- Infinite scroll (paginação)
- Skeleton loading
- Imagens com cache
- Badge de desconto

#### Filtros
- Busca por nome
- Filtro por categoria
- Filtro por faixa de preço
- Combinação de filtros

#### Detalhes do Produto
- Galeria de imagens
- Informações completas
- Preço com desconto
- Material e categoria

### Whitelabel

- Buscar configuração do cliente
- Aplicar cores dinamicamente
- Exibir logo do cliente
- ThemeData dinâmico

## 📁 Estrutura de Arquivos Completa

### Core

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String clientDomain = 'cliente1.local';
  static const String tokenKey = 'auth_token';
}

// lib/core/network/api_client.dart
class ApiClient {
  late final Dio _dio;
  // Interceptors para token e headers
}

// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme(String? primaryColor) {
    // Tema dinâmico baseado na cor do cliente
  }
}
```

### Domain (Entities)

```dart
// lib/domain/entities/user_entity.dart
class UserEntity extends Equatable {
  final int id;
  final String email;
  final String name;
  final ClientEntity client;
}

// lib/domain/entities/client_entity.dart
class ClientEntity extends Equatable {
  final int id;
  final String name;
  final String? logoUrl;
  final String? primaryColor;
}

// lib/domain/entities/product_entity.dart
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  // ... outros campos

  double get finalPrice {
    if (hasDiscount) {
      return price * (1 - discountValue);
    }
    return price;
  }
}
```

### Data (Models & Repositories)

```dart
// lib/data/models/user_model.dart
class UserModel extends UserEntity {
  const UserModel({...}) : super(...);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse JSON
  }
}

// lib/data/providers/auth_provider.dart
class AuthProvider {
  final ApiClient _apiClient;

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _apiClient.dio.post('/auth/login', ...);
    return AuthResponseModel.fromJson(response.data);
  }
}

// lib/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthProvider _provider;
  final FlutterSecureStorage _storage;

  @override
  Future<Either<Failure, AuthResponseEntity>> login(...) async {
    try {
      final result = await _provider.login(email, password);
      await _storage.write(key: tokenKey, value: result.accessToken);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

### Presentation (BLoC & Pages)

```dart
// lib/presentation/auth/blocs/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(email, password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (auth) => emit(AuthAuthenticated(user: auth.user)),
    );
  }
}

// lib/presentation/auth/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/products');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingIndicator();
        }
        return LoginForm(); // Formulário de login
      },
    );
  }
}

// lib/presentation/products/blocs/products_bloc.dart
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase})
      : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<FilterProducts>(_onFilterProducts);
  }
}

// lib/presentation/products/pages/products_list_page.dart
class ProductsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return GridView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: state.products[index]);
            },
          );
        }
        return ShimmerLoading();
      },
    );
  }
}
```

### Dependency Injection

```dart
// lib/core/di/injection.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() => ApiClient());

  // Data providers
  getIt.registerLazySingleton(() => AuthProvider(getIt()));
  getIt.registerLazySingleton(() => ProductsProvider(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));

  // BLoCs
  getIt.registerFactory(() => AuthBloc(loginUseCase: getIt()));
  getIt.registerFactory(() => ProductsBloc(getProductsUseCase: getIt()));
}
```

### Main

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup DI
  setupDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ProductsBloc>()),
      ],
      child: MaterialApp(
        title: 'E-commerce Whitelabel',
        theme: AppTheme.lightTheme(null),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/products': (context) => ProductsListPage(),
          '/product-details': (context) => ProductDetailsPage(),
        },
      ),
    );
  }
}
```

## 🎨 Whitelabel Dinâmico

### 1. Buscar configuração ao iniciar

```dart
// No SplashScreen
final client = await clientRepository.getClientConfig();
final theme = AppTheme.lightTheme(client.primaryColor);
```

### 2. Aplicar tema

```dart
MaterialApp(
  theme: theme,
  // ...
)
```

### 3. Exibir logo

```dart
// Na AppBar ou tela de login
CachedNetworkImage(
  imageUrl: client.logoUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

## 🧪 Testando

### Unit Tests

```dart
// test/domain/usecases/login_usecase_test.dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = LoginUseCase(mockRepo);
  });

  test('should return AuthResponse on success', () async {
    // Arrange
    when(mockRepo.login(any, any)).thenAnswer((_) async => Right(authResponse));

    // Act
    final result = await useCase('email', 'password');

    // Assert
    expect(result, Right(authResponse));
  });
}
```

### Widget Tests

```dart
// test/presentation/auth/login_page_test.dart
void main() {
  testWidgets('should display login form', (tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });
}
```

## 📸 Screenshots

(Adicionar screenshots aqui)

## 🔧 Troubleshooting

### Erro: Cannot connect to backend
- Verifique se o backend está rodando
- Confirme a URL em `app_config.dart`
- Para Android emulator, use: `http://10.0.2.2:3000`
- Para iOS simulator, use: `http://localhost:3000`

### Erro: Token expired
- Faça login novamente
- Verifique a expiração do JWT no backend

## 📚 Recursos

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Pattern](https://bloclibrary.dev)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Desenvolvido para o teste técnico Devnology**
