import '../../data/repositories/client_repository_impl.dart';
import '../entities/client_entity.dart';

class GetClientConfigUseCase {
  final ClientRepository _repository;

  GetClientConfigUseCase(this._repository);

  Future<ClientEntity> call() {
    return _repository.getClientConfig();
  }
}
