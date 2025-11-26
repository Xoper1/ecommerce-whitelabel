import '../../domain/entities/client_entity.dart';
import '../providers/client_provider.dart';

abstract class ClientRepository {
  Future<ClientEntity> getClientConfig();
}

class ClientRepositoryImpl implements ClientRepository {
  final ClientProvider _provider;

  ClientRepositoryImpl(this._provider);

  @override
  Future<ClientEntity> getClientConfig() async {
    return await _provider.getClientConfig();
  }
}
