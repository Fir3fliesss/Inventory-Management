import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/product_controller.dart';
import '../../../category/domain/category_controller.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CategoryController categoryController = Get.put(CategoryController());
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final costController =
        TextEditingController(); // Tambahkan controller untuk cost
    final stockController = TextEditingController();
    final minStockController = TextEditingController();
    final descriptionController = TextEditingController();
    RxString selectedCategoryId = ''.obs;

    // Pastikan kategori dimuat sebelum form ditampilkan
    categoryController.fetchCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Produk')),
      body: Padding(
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
                  value: selectedCategoryId.value.isEmpty
                      ? null
                      : selectedCategoryId.value,
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
                controller: costController, // Tambahkan field untuk cost
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
                decoration: const InputDecoration(labelText: 'Stok Minimum'),
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
                        try {
                          // Konversi category_id ke UUID string yang valid
                          final categoryId = selectedCategoryId.value.trim();

                          if (categoryId.isEmpty) {
                            Get.snackbar('Error', 'Kategori tidak boleh kosong');
                            return;
                          }

                          // Konversi nilai-nilai numerik dengan benar
                          int stock = 0;
                          int minStock = 0;
                          double price = 0.0;

                          try {
                            stock = int.parse(stockController.text);
                          } catch (e) {
                            Get.snackbar('Error', 'Stok harus berupa angka');
                            return;
                          }

                          try {
                            minStock = int.parse(minStockController.text);
                          } catch (e) {
                            Get.snackbar('Error', 'Stok minimum harus berupa angka');
                            return;
                          }

                          try {
                            price = double.parse(priceController.text);
                          } catch (e) {
                            Get.snackbar('Error', 'Harga harus berupa angka');
                            return;
                          }

                          final productData = {
                            'name': nameController.text,
                            'barcode': barcodeController.text.isNotEmpty ? barcodeController.text : null,
                            'category_id': categoryId,
                            'price': price,
                            'stock': stock,
                            'min_stock': minStock,
                            'description': descriptionController.text.isNotEmpty ? descriptionController.text : null,
                          };

                          print('Data produk yang akan dikirim: $productData');
                          productController.addProduct(productData);
                        } catch (e) {
                          Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
                        }
                      },
                      child: const Text('Simpan'),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
