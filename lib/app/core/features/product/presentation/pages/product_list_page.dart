import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import 'add_product_page.dart';
import 'product_detail_page.dart';
import '../../../search_filter/presentation/widgets/search_bar_widget.dart';
import '../../../search_filter/presentation/widgets/filter_dialog.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Get unique categories using the new method
              final uniqueCategories = controller.getUniqueCategories();

              // Add "All" category if needed
              if (!uniqueCategories.any((cat) => cat['id'] == 'all')) {
                uniqueCategories.insert(0, {
                  'id': 'all',
                  'name': 'Semua Kategori',
                });
              }

              // Show filter dialog with extracted categories
              Get.dialog(
                FilterDialog(
                  controller: controller.searchFilter,
                  categories: uniqueCategories,
                  onApply: () {
                    // Filters will be applied automatically through reactive bindings
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddProductPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          SearchBarWidget(
            onSearch: (query) {
              controller.searchFilter.updateSearchQuery(query);
            },
          ),

          // Product list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = controller.filteredProducts;

              if (products.isEmpty) {
                return const Center(
                  child: Text('Tidak ada produk yang ditemukan'),
                );
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  // Get category name for display
                  final categoryName = controller.getCategoryName(product['category_id']?.toString() ?? '');

                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stok: ${product['stock']}'),
                        Text('Kategori: $categoryName'),
                      ],
                    ),
                    trailing: product['stock'] <= product['min_stock']
                        ? const Icon(Icons.warning, color: Colors.red)
                        : Text('Rp ${product['price']}'),
                    onTap: () =>
                        Get.to(() => ProductDetailPage(productId: product['id'])),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
