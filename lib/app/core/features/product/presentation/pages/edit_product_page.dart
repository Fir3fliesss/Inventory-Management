import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import '../../../category/domain/category_controller.dart';

class EditProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CategoryController categoryController = Get.put(CategoryController());
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final costController = TextEditingController();
    final stockController = TextEditingController();
    final minStockController = TextEditingController();
    final descriptionController = TextEditingController();
    RxString selectedCategoryId = ''.obs; // Deklarasi RxString untuk kategori

    // Pastikan kategori dimuat
    categoryController.fetchCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: FutureBuilder<Map<String, dynamic>>(
        // Change this line to use the product ID instead of the entire product map
        future: productController.getProductById(product['id']),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Produk tidak ditemukan'));
          }

          final product = snapshot.data!;
          nameController.text = product['name'] ?? '';
          barcodeController.text = product['barcode'] ?? '';
          priceController.text = product['price']?.toString() ?? '';
          costController.text = product['cost']?.toString() ?? '';
          stockController.text = product['stock']?.toString() ?? '';
          minStockController.text = product['min_stock']?.toString() ?? '';
          descriptionController.text = product['description'] ?? '';
          selectedCategoryId.value =
              product['category_id'] ?? ''; // Set nilai awal

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                  Obx(() {
                    if (categoryController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (categoryController.categories.isEmpty) {
                      return const Text('Tidak ada kategori tersedia');
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      value: selectedCategoryId.value.isNotEmpty
                          ? selectedCategoryId.value
                          : null,
                      items: categoryController.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'],
                          child: Text(category['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategoryId.value = value;
                          print('Kategori dipilih: $value'); // Debug log
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih kategori terlebih dahulu';
                        }
                        return null;
                      },
                    );
                  }),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: costController,
                    decoration: const InputDecoration(labelText: 'Harga Beli'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(labelText: 'Stok Awal'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: minStockController,
                    decoration:
                        const InputDecoration(labelText: 'Stok Minimum'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => productController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (selectedCategoryId.value.isEmpty) {
                              Get.snackbar(
                                  'Error', 'Pilih kategori terlebih dahulu');
                              return;
                            }
                            if (costController.text.isEmpty) {
                              Get.snackbar('Error', 'Masukkan harga beli');
                              return;
                            }
                            final updatedProduct = {
                              'name': nameController.text,
                              'barcode': barcodeController.text,
                              'category_id': selectedCategoryId.value,
                              'price':
                                  double.tryParse(priceController.text) ?? 0.0,
                              'cost':
                                  double.tryParse(costController.text) ?? 0.0,
                              'stock': int.tryParse(stockController.text) ?? 0,
                              'min_stock':
                                  int.tryParse(minStockController.text) ?? 0,
                              'description': descriptionController.text,
                            };
                            print(
                                'Data yang akan diperbarui: $updatedProduct'); // Debug log
                            productController.updateProduct(
                                product['id'], updatedProduct);
                          },
                          child: const Text('Simpan'),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
