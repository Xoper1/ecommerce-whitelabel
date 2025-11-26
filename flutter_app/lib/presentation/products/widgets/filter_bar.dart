import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  final Function({
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) onFilterApplied;

  final String? initialSearch;
  final String? initialCategory;
  final double? initialMinPrice;
  final double? initialMaxPrice;

  const FilterBar({
    super.key,
    required this.onFilterApplied,
    this.initialSearch,
    this.initialCategory,
    this.initialMinPrice,
    this.initialMaxPrice,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final _searchController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialSearch ?? '';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final minPriceController = TextEditingController(
          text: widget.initialMinPrice?.toString() ?? '',
        );
        final maxPriceController = TextEditingController(
          text: widget.initialMaxPrice?.toString() ?? '',
        );

        return AlertDialog(
          title: const Text('Filtros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: minPriceController,
                decoration: const InputDecoration(
                  labelText: 'Preço Mínimo',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxPriceController,
                decoration: const InputDecoration(
                  labelText: 'Preço Máximo',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onFilterApplied(
                  search: _searchController.text.isEmpty
                      ? null
                      : _searchController.text,
                  minPrice: null,
                  maxPrice: null,
                );
              },
              child: const Text('Limpar'),
            ),
            ElevatedButton(
              onPressed: () {
                final minPrice = double.tryParse(minPriceController.text);
                final maxPrice = double.tryParse(maxPriceController.text);

                Navigator.pop(context);
                widget.onFilterApplied(
                  search: _searchController.text.isEmpty
                      ? null
                      : _searchController.text,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                );
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar produtos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.onFilterApplied(search: null);
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) {
                widget.onFilterApplied(
                  search: value.isEmpty ? null : value,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filtros',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
