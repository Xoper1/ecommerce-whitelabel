# Guia de Implementação - Flutter App


## 📋 Índice

1. [Setup Inicial](#1-setup-inicial)
2. [Data Layer](#2-data-layer)
3. [Domain Layer](#3-domain-layer)
4. [Presentation Layer](#4-presentation-layer)
5. [Dependency Injection](#5-dependency-injection)
6. [Temas e Whitelabel](#6-temas-e-whitelabel)
7. [Navegação](#7-navegação)
8. [Testes](#8-testes)

---

## 1. Setup Inicial

### Instalar Dependências

```bash
flutter pub get
```

### Verificar Estrutura

A estrutura já está criada:
```
lib/
├── core/
│   ├── config/
│   ├── network/
│   └── theme/
├── data/
│   ├── models/
│   ├── providers/
│   └── repositories/
├── domain/
│   ├── entities/    ✅ CRIADO
│   └── usecases/
└── presentation/
    ├── auth/
    └── products/
```

---

## 2. Data Layer

### 2.1. Models

Crie os modelos que convertem JSON ↔ Entities:

**`lib/data/models/client_model.dart`**
```dart
import '../../domain/entities/client_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.id,
    required super.name,
    super.logoUrl,
    super.primaryColor,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      primaryColor: json['primary_color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'primary_color': primaryColor,
    };
  }
}
```

**`lib/data/models/user_model.dart`**
```dart
import '../../domain/entities/user_entity.dart';
import 'client_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.client,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
    );
  }
}
```

**`lib/data/models/product_model.dart`**
```dart
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.category,
    required super.images,
    required super.material,
    required super.hasDiscount,
    required super.discountValue,
    required super.provider,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
      material: json['material'] as String? ?? '',
      hasDiscount: json['hasDiscount'] as bool? ?? false,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      provider: json['provider'] as String,
    );
  }
}
```

**`lib/data/models/auth_response_model.dart`**
```dart
import '../../domain/entities/auth_response_entity.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.accessToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
```

### 2.2. Providers (API Calls)

**`lib/data/providers/auth_provider.dart`**
```dart
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/auth_response_model.dart';

class AuthProvider {
  final ApiClient _apiClient;

  AuthProvider(this._apiClient);

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<AuthResponseModel> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
    }
  }
}
```

**`lib/data/providers/products_provider.dart`**
```dart
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductsProvider {
  final ApiClient _apiClient;

  ProductsProvider(this._apiClient);

  Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: queryParams,
      );

      return (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load products');
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Product not found');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/products/categories');
      return (response.data as List).map((e) => e as String).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load categories');
    }
  }
}
```

**`lib/data/providers/client_provider.dart`**
```dart
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/client_model.dart';

class ClientProvider {
  final ApiClient _apiClient;

  ClientProvider(this._apiClient);

  Future<ClientModel> getClientConfig() async {
    try {
      final response = await _apiClient.dio.get('/clients/config');
      return ClientModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load client config');
    }
  }
}
```

### 2.3. Repositories Implementation

**`lib/data/repositories/auth_repository_impl.dart`**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/app_config.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../providers/auth_provider.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(String email, String password);
  Future<AuthResponseEntity> register(String email, String password, String name);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isAuthenticated();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthProvider _provider;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this._provider, this._storage);

  @override
  Future<AuthResponseEntity> login(String email, String password) async {
    final result = await _provider.login(email, password);
    await _storage.write(key: AppConfig.tokenKey, value: result.accessToken);
    return result;
  }

  @override
  Future<AuthResponseEntity> register(
    String email,
    String password,
    String name,
  ) async {
    final result = await _provider.register(email, password, name);
    await _storage.write(key: AppConfig.tokenKey, value: result.accessToken);
    return result;
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: AppConfig.tokenKey);
    await _storage.delete(key: AppConfig.userKey);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: AppConfig.tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
```

---

## 3. Domain Layer

### 3.1. UseCases

**`lib/domain/usecases/login_usecase.dart`**
```dart
import '../entities/auth_response_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResponseEntity> call(String email, String password) {
    return _repository.login(email, password);
  }
}
```

**`lib/domain/usecases/get_products_usecase.dart`**
```dart
import '../entities/product_entity.dart';
import '../../data/repositories/products_repository_impl.dart';

class GetProductsUseCase {
  final ProductsRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) {
    return _repository.getProducts(
      search: search,
      category: category,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}
```

---

## 4. Presentation Layer

### 4.1. BLoCs

**`lib/presentation/auth/blocs/auth_event.dart`**
```dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
```

**`lib/presentation/auth/blocs/auth_state.dart`**
```dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

**`lib/presentation/auth/blocs/auth_bloc.dart`**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final authResponse = await _loginUseCase(event.email, event.password);
      emit(AuthAuthenticated(user: authResponse.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Clear storage
    emit(AuthUnauthenticated());
  }
}
```

### 4.2. Pages

**`lib/presentation/auth/pages/login_page.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/products');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              LoginRequested(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

## 5. Dependency Injection

**`lib/core/di/injection.dart`**
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/products_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../presentation/auth/blocs/auth_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Providers
  getIt.registerLazySingleton(() => AuthProvider(getIt()));
  getIt.registerLazySingleton(() => ProductsProvider(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));

  // BLoCs
  getIt.registerFactory(() => AuthBloc(loginUseCase: getIt()));
}
```

---

## 6. Próximos Passos

1. Implemente ProductsBloc similar ao AuthBloc
2. Crie ProductsListPage e ProductDetailsPage
3. Implemente filtros e busca
4. Adicione whitelabel dinâmico
5. Crie widgets reutilizáveis (ProductCard, FilterBar)
6. Adicione testes unitários e de widget

