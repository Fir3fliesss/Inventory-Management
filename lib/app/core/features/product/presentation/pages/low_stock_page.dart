import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import 'product_detail_page.dart';

class LowStockPage extends StatelessWidget {
  const LowStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ProductController
    final ProductController controller = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Rendah'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('Tidak ada produk dengan stok rendah'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            final int stock = product['stock'] ?? 0;
            final int minStock = product['min_stock'] ?? 0;
            if (stock >= minStock) return Container(); // Skip products not low on stock

            return Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text(product['name'] ?? 'Produk tidak diketahui'),
                subtitle: Text('Stok: $stock, Minimum: $minStock'),
                onTap: () => Get.to(() => ProductDetailPage(productId: product['id'])),
              ),
            );
          },
        );
      }),
    );
  }
}
