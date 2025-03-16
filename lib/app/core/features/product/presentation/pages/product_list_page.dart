import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import 'add_product_page.dart';
import 'product_detail_page.dart';

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
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddProductPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('Tidak ada produk'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product['name']),
              subtitle: Text('Stok: ${product['stock']}'),
              trailing: product['stock'] <= product['min_stock']
                  ? const Icon(Icons.warning, color: Colors.red)
                  : null,
              onTap: () =>
                  Get.to(() => ProductDetailPage(productId: product['id'])),
            );
          },
        );
      }),
    );
  }
}
