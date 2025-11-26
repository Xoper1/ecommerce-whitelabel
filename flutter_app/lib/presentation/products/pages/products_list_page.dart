import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/products_bloc.dart';
import '../blocs/products_event.dart';
import '../blocs/products_state.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_bar.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  String? _searchQuery;
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(const LoadProducts());
  }

  void _applyFilters({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) {
    setState(() {
      _searchQuery = search;
      _selectedCategory = category;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
    });

    context.read<ProductsBloc>().add(
          LoadProducts(
            search: search,
            category: category,
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FilterBar(
            onFilterApplied: _applyFilters,
            initialSearch: _searchQuery,
            initialCategory: _selectedCategory,
            initialMinPrice: _minPrice,
            initialMaxPrice: _maxPrice,
          ),
          Expanded(
            child: BlocBuilder<ProductsBloc, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar produtos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ProductsBloc>()
                                .add(const LoadProducts());
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum produto encontrado',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductsBloc>().add(RefreshProducts());
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product.id,
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const Center(child: Text('Carregando...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
