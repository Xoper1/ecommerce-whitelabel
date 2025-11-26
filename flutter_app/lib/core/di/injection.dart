import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/products_provider.dart';
import '../../data/providers/client_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_client_config_usecase.dart';
import '../../presentation/auth/blocs/auth_bloc.dart';
import '../../presentation/products/blocs/products_bloc.dart';
import '../../presentation/theme/blocs/theme_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Core
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Providers
  getIt.registerLazySingleton(() => AuthProvider(getIt()));
  getIt.registerLazySingleton(() => ProductsProvider(getIt()));
  getIt.registerLazySingleton(() => ClientProvider(getIt()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetProductDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetClientConfigUseCase(getIt()));

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      registerUseCase: getIt(),
      authRepository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => ProductsBloc(
      getProductsUseCase: getIt(),
      getProductDetailsUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => ThemeBloc(
      getClientConfigUseCase: getIt(),
    ),
  );
}
