import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../product/domain/product_controller.dart';
import '../../domain/transaction_controller.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.find<TransactionController>();
    final ProductController productController = Get.find<ProductController>();
    final quantityController = TextEditingController();
    RxString selectedProductId = ''.obs;
    RxString selectedType = 'in'.obs;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (productController.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Produk'),
                value: selectedProductId.value.isEmpty
                    ? null
                    : selectedProductId.value,
                items: productController.products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product['id'],
                    child: Text(product['name']),
                  );
                }).toList(),
                onChanged: (value) => selectedProductId.value = value ?? '',
              );
            }),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Tipe Transaksi'),
              value: selectedType.value,
              items: const [
                DropdownMenuItem(value: 'in', child: Text('Stok Masuk')),
                DropdownMenuItem(value: 'out', child: Text('Stok Keluar')),
              ],
              onChanged: (value) => selectedType.value = value ?? 'in',
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Obx(() => transactionController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (selectedProductId.value.isEmpty ||
                          quantityController.text.isEmpty) {
                        Get.snackbar('Error', 'Lengkapi semua field');
                        return;
                      }
                      final transactionData = {
                        'product_id': selectedProductId.value,
                        'type': selectedType.value,
                        'quantity': int.parse(quantityController.text),
                      };
                      transactionController.addTransaction(transactionData);
                    },
                    child: const Text('Simpan'),
                  )),
          ],
        ),
      ),
    );
  }
}
