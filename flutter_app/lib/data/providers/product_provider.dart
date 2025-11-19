import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../../core/network/api_client.dart';

class ProductProvider {
  final ApiClient _apiClient;

  ProductProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Dados de fallback para testes (quando backend não está disponível)
  static List<ProductModel> _getMockProducts() {
    return [
      ProductModel(
        id: 'mock_1',
        name: 'Camisa Polo Premium',
        description: 'Camisa polo de algodão 100%, confortável e durável',
        price: 127.00,
        category: 'Vestuário',
        images: [
          'https://via.placeholder.com/300x300?text=Camisa+Polo',
        ],
        material: 'Algodão',
        hasDiscount: true,
        discountValue: 27.00,
        provider: 'brazilian',
      ),
      ProductModel(
        id: 'mock_2',
        name: 'Jaqueta Impermeável',
        description: 'Jaqueta resistente à água, ideal para chuva',
        price: 299.99,
        category: 'Vestuário',
        images: [
          'https://via.placeholder.com/300x300?text=Jaqueta',
        ],
        material: 'Poliéster',
        hasDiscount: false,
        discountValue: 0,
        provider: 'brazilian',
      ),
      ProductModel(
        id: 'mock_3',
        name: 'Sapato Social',
        description: 'Sapato social elegante, perfeito para eventos',
        price: 199.90,
        category: 'Calçados',
        images: [
          'https://via.placeholder.com/300x300?text=Sapato',
        ],
        material: 'Couro',
        hasDiscount: true,
        discountValue: 50.00,
        provider: 'european',
      ),
      ProductModel(
        id: 'mock_4',
        name: 'Relógio Analógico',
        description: 'Relógio clássico com pulseira de couro',
        price: 450.00,
        category: 'Acessórios',
        images: [
          'https://via.placeholder.com/300x300?text=Relogio',
        ],
        material: 'Aço',
        hasDiscount: false,
        discountValue: 0,
        provider: 'european',
      ),
      ProductModel(
        id: 'mock_5',
        name: 'Mochila Executiva',
        description: 'Mochila espaçosa com compartimentos organizadores',
        price: 220.00,
        category: 'Acessórios',
        images: [
          'https://via.placeholder.com/300x300?text=Mochila',
        ],
        material: 'Poliéster resistente',
        hasDiscount: true,
        discountValue: 50.00,
        provider: 'brazilian',
      ),
      ProductModel(
        id: 'mock_6',
        name: 'Óculos de Sol',
        description: 'Óculos com proteção UV 100%',
        price: 180.00,
        category: 'Acessórios',
        images: [
          'https://via.placeholder.com/300x300?text=Oculos',
        ],
        material: 'Plástico e vidro',
        hasDiscount: false,
        discountValue: 0,
        provider: 'european',
      ),
    ];
  }

  /// Busca lista de produtos com filtros opcionais
  Future<List<ProductModel>> getProducts({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (minPrice != null) {
        queryParams['minPrice'] = minPrice;
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice;
      }

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is List ? response.data : response.data['data'] ?? [];

        return data
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load products: ${response.statusCode}');
    } on DioException catch (e) {
      // Se 404, retornar dados simulados com mensagem informativa
      if (e.response?.statusCode == 404) {
        print(
          '⚠️  Backend retornou 404. Verifique se:\n'
          '   1. O banco de dados foi criado (execute docs/database.sql)\n'
          '   2. O cliente "cliente1.local" existe na tabela "clients"\n'
          '   3. O backend está rodando com npm run start:dev\n'
          'Usando dados de teste para demonstração.',
        );
        // Retornar dados simulados para testes
        var mockData = _getMockProducts();

        // Aplicar filtros aos dados simulados
        if (search != null && search.isNotEmpty) {
          mockData = mockData
              .where((p) =>
                  p.name.toLowerCase().contains(search.toLowerCase()) ||
                  p.description.toLowerCase().contains(search.toLowerCase()))
              .toList();
        }
        if (category != null && category.isNotEmpty) {
          mockData = mockData.where((p) => p.category == category).toList();
        }
        if (minPrice != null) {
          mockData = mockData.where((p) => p.price >= minPrice).toList();
        }
        if (maxPrice != null) {
          mockData = mockData.where((p) => p.price <= maxPrice).toList();
        }

        return mockData;
      }
      // Se não conseguir conectar ao backend
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        print(
          '⚠️  Servidor indisponível em http://localhost:3000\n'
          'Verifique se o backend está rodando com: npm run start:dev',
        );
        // Retornar dados simulados também para timeout
        return _getMockProducts();
      }
      throw Exception('Erro de rede: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao carregar produtos: $e');
    }
  }

  /// Busca um produto específico pelo ID
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to load product: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  /// Busca categorias disponíveis
  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/products/categories');

      if (response.statusCode == 200) {
        final List<dynamic> data =
            response.data is List ? response.data : response.data['data'] ?? [];

        return data.map((item) => item.toString()).toList();
      }

      throw Exception('Failed to load categories: ${response.statusCode}');
    } on DioException catch (e) {
      // Se erro, retornar categorias dos dados simulados
      if (e.response?.statusCode == 404 ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return _getMockProducts().map((p) => p.category).toSet().toList()
          ..sort();
      }
      throw Exception('Erro de rede: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }
}
