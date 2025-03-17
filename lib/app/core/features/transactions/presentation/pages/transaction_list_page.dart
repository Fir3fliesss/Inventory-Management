import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/transaction_controller.dart';

class TransactionListPage extends StatelessWidget {
  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController =
        Get.put(TransactionController());

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Transaksi')),
      body: Obx(() {
        if (transactionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (transactionController.transactions.isEmpty) {
          return const Center(child: Text('Tidak ada transaksi'));
        }
        return ListView.builder(
          itemCount: transactionController.transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactionController.transactions[index];
            return ListTile(
              title: Text(
                  'Produk: ${transaction.productId}'), // Ganti dengan nama produk dari join
              subtitle: Text(
                  'Tipe: ${transaction.type}, Jumlah: ${transaction.quantity}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Konfirmasi',
                    middleText: 'Hapus transaksi ini?',
                    confirm: ElevatedButton(
                      onPressed: () {
                        transactionController.deleteTransaction(transaction.id);
                        Get.back();
                      },
                      child: const Text('Hapus'),
                    ),
                    cancel: ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/transaction/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
