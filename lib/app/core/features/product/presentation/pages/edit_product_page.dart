import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';

class EditProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final nameController = TextEditingController(text: product['name']);
    final barcodeController = TextEditingController(text: product['barcode']);
    final priceController =
        TextEditingController(text: product['price'].toString());
    final stockController =
        TextEditingController(text: product['stock'].toString());
    final minStockController =
        TextEditingController(text: product['min_stock'].toString());
    final descriptionController =
        TextEditingController(text: product['description']);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            TextField(
              controller: barcodeController,
              decoration: const InputDecoration(labelText: 'Barcode'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: minStockController,
              decoration: const InputDecoration(labelText: 'Stok Minimum'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      final updates = {
                        'name': nameController.text,
                        'barcode': barcodeController.text,
                        'price': double.parse(priceController.text),
                        'stock': int.parse(stockController.text),
                        'min_stock': int.parse(minStockController.text),
                        'description': descriptionController.text,
                      };
                      controller.updateProduct(product['id'], updates);
                    },
                    child: const Text('Simpan'),
                  )),
          ],
        ),
      ),
    );
  }
}
