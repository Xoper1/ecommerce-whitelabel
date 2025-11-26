import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/app_config.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../providers/auth_provider.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(String email, String password);
  Future<AuthResponseEntity> register(
      String email, String password, String name);
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
