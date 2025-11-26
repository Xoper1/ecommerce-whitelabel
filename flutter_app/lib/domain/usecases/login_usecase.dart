import '../../data/repositories/auth_repository_impl.dart';
import '../entities/auth_response_entity.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthResponseEntity> call(String email, String password) {
    return _repository.login(email, password);
  }
}
