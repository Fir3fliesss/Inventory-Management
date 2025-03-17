import 'package:get/get.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../product/domain/product_controller.dart';
import '../../transactions/data/transaction_model.dart';
import '../../dashboard/domain/dashboard_controller.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepository = TransactionRepository();
  late final ProductController _productController;

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Coba find dulu, kalau tidak ada baru put
    _productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      transactions.value = await _transactionRepository.getAllTransactions();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    isLoading.value = true;
    try {
      // Cari produk berdasarkan ID
      final product = _productController.products.firstWhere(
        (p) => p['id'] == transactionData['product_id'],
        orElse: () => throw Exception('Produk tidak ditemukan'),
      );

      // Validasi stok untuk transaksi keluar
      if (transactionData['type'] == 'out' &&
          product['stock'] < transactionData['quantity']) {
        throw Exception('Stok tidak mencukupi');
      }

      // Hitung stok baru berdasarkan tipe transaksi
      int newStock = transactionData['type'] == 'in'
          ? product['stock'] + transactionData['quantity']
          : product['stock'] - transactionData['quantity'];

      // Tambahkan transaksi ke database
      await _transactionRepository.addTransaction(transactionData);

      // Update stok produk di database
      await _productController.updateProduct(product['id'], {'stock': newStock});

      // Refresh data transaksi
      fetchTransactions();

      // Refresh data produk untuk memastikan UI terupdate
      await _productController.fetchProducts();

      // Perbarui dashboard jika ada
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshDashboard();
      }

      Get.back();
      Get.snackbar('Sukses', 'Transaksi berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    isLoading.value = true;
    try {
      // Cari transaksi yang akan dihapus
      final transaction = transactions.firstWhere((t) => t.id == transactionId);

      // Cari produk terkait
      final product = _productController.products
          .firstWhere((p) => p['id'] == transaction.productId);

      // Hitung penyesuaian stok (kebalikan dari transaksi asli)
      int stockAdjustment = transaction.type == 'in'
          ? -transaction.quantity  // Jika transaksi masuk, kurangi stok
          : transaction.quantity;  // Jika transaksi keluar, tambah stok

      // Update stok produk
      await _productController.updateProduct(
          product['id'], {'stock': product['stock'] + stockAdjustment});

      // Hapus transaksi dari database
      await _transactionRepository.deleteTransaction(transactionId);

      // Refresh data
      fetchTransactions();
      await _productController.fetchProducts();

      // Perbarui dashboard jika ada
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshDashboard();
      }

      Get.snackbar('Sukses', 'Transaksi berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
