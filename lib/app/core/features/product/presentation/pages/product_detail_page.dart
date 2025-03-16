import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import 'edit_product_page.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return FutureBuilder<Map<String, dynamic>>(
      future: controller.getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        }
        final product = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(product['name']),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    Get.to(() => EditProductPage(product: product)),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Hapus Produk'),
                      content: const Text(
                          'Apakah Anda yakin ingin menghapus produk ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    controller.deleteProduct(productId);
                  }
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${product['name']}'),
                Text('Barcode: ${product['barcode'] ?? 'Tidak ada'}'),
                Text('Kategori: ${product['categories']['name']}'),
                Text('Harga: ${product['price']}'),
                Text('Stok: ${product['stock']}'),
                Text('Stok Minimum: ${product['min_stock']}'),
                Text('Deskripsi: ${product['description'] ?? 'Tidak ada'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
