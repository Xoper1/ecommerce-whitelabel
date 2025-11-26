import '../../data/repositories/auth_repository_impl.dart';
import '../entities/auth_response_entity.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<AuthResponseEntity> call(String email, String password, String name) {
    return _repository.register(email, password, name);
  }
}
