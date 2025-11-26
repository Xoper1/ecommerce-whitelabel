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
      throw Exception(
          e.response?.data['message'] ?? 'Failed to load client config');
    }
  }
}
