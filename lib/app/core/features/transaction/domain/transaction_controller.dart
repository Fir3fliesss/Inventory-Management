import 'package:get/get.dart';
import '../../transactions/data/transaction_repository.dart';

class TransactionController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();

  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    try {
      transactionData['timestamp'] = DateTime.now().toIso8601String(); // Add timestamp
      await _repository.addTransaction(transactionData);
      Get.snackbar('Sukses', 'Transaksi berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah transaksi: $e');
    }
  }

  // ... other methods ...
}
