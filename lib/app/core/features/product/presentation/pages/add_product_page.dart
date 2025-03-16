import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final minStockController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
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
              decoration: const InputDecoration(labelText: 'Stok Awal'),
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
                      final productData = {
                        'name': nameController.text,
                        'barcode': barcodeController.text,
                        'price': double.parse(priceController.text),
                        'stock': int.parse(stockController.text),
                        'min_stock': int.parse(minStockController.text),
                        'description': descriptionController.text,
                        // 'category_id' akan ditambahkan nanti saat kategori diimplementasikan
                      };
                      controller.addProduct(productData);
                    },
                    child: const Text('Simpan'),
                  )),
          ],
        ),
      ),
    );
  }
}
