// import 'package:get/get.rx.dart';
import 'package:get/get.dart';
import '../data/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();

  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      products.value = await _repository.getAllProducts();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      return await _repository.getProductById(productId);
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    isLoading.value = true;
    try {
      // Create a new map to avoid modifying the original
      final Map<String, dynamic> sanitizedData = {...productData};

      // Ensure all numeric fields are properly converted
      if (sanitizedData.containsKey('min_stock')) {
        if (sanitizedData['min_stock'] is String) {
          sanitizedData['min_stock'] = int.tryParse(sanitizedData['min_stock']) ?? 0;
        }
      }

      if (sanitizedData.containsKey('stock')) {
        if (sanitizedData['stock'] is String) {
          sanitizedData['stock'] = int.tryParse(sanitizedData['stock']) ?? 0;
        }
      }

      if (sanitizedData.containsKey('price')) {
        if (sanitizedData['price'] is String) {
          sanitizedData['price'] = double.tryParse(sanitizedData['price']) ?? 0.0;
        }
      }

      if (sanitizedData.containsKey('cost')) {
        if (sanitizedData['cost'] is String) {
          sanitizedData['cost'] = double.tryParse(sanitizedData['cost']) ?? 0.0;
        }
      }

      // Debug log to see what's being sent
      print('Sending sanitized data to repository: $sanitizedData');

      await _repository.addProduct(sanitizedData);
      fetchProducts(); // Refresh daftar produk
      Get.back(); // Kembali ke daftar produk
      Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
    } catch (e) {
      print('Error details: $e'); // More detailed error logging
      Get.snackbar('Error', 'Gagal menambah produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    isLoading.value = true;
    try {
      // Create a new map to avoid modifying the original
      final Map<String, dynamic> sanitizedUpdates = {...updates};

      // Ensure all numeric fields are properly converted
      if (sanitizedUpdates.containsKey('min_stock')) {
        if (sanitizedUpdates['min_stock'] is String) {
          sanitizedUpdates['min_stock'] = int.tryParse(sanitizedUpdates['min_stock']) ?? 0;
        }
      }

      if (sanitizedUpdates.containsKey('stock')) {
        if (sanitizedUpdates['stock'] is String) {
          sanitizedUpdates['stock'] = int.tryParse(sanitizedUpdates['stock']) ?? 0;
        }
      }

      if (sanitizedUpdates.containsKey('price')) {
        if (sanitizedUpdates['price'] is String) {
          sanitizedUpdates['price'] = double.tryParse(sanitizedUpdates['price']) ?? 0.0;
        }
      }

      if (sanitizedUpdates.containsKey('cost')) {
        if (sanitizedUpdates['cost'] is String) {
          sanitizedUpdates['cost'] = double.tryParse(sanitizedUpdates['cost']) ?? 0.0;
        }
      }

      // Debug log
      print('Sending sanitized updates to repository: $sanitizedUpdates');

      await _repository.updateProduct(productId, sanitizedUpdates);
      fetchProducts(); // Refresh daftar produk
      Get.back(); // Kembali ke daftar produk
      Get.snackbar('Sukses', 'Produk berhasil diperbarui');
    } catch (e) {
      print('Error details: $e'); // More detailed error logging
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    isLoading.value = true;
    try {
      await _repository.deleteProduct(productId);
      fetchProducts(); // Refresh daftar produk

      // Navigate back to product list page
      Get.offAllNamed('/products'); // This will replace all screens with the product list

      Get.snackbar('Sukses', 'Produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLowStockProducts() async {
    isLoading.value = true;
    try {
      // Get all products that have stock below min_stock
      final lowStockProducts = await _repository.getLowStockProducts();

      // Count total items that need restocking
      int totalLowStockItems = 0;

      // Calculate how many items need to be restocked for each product
      for (var product in lowStockProducts) {
        int currentStock = product['stock'] ?? 0;
        int minStock = product['min_stock'] ?? 0;

        // If current stock is below minimum, calculate the deficit
        if (currentStock < minStock) {
          int deficit = minStock - currentStock;
          // Add this information to the product map for UI display
          product['deficit'] = deficit;
          totalLowStockItems += deficit;
        }
      }

      // Show notification with count of products and total items needed
      Get.snackbar(
        'Stok Rendah',
        'Terdapat ${lowStockProducts.length} produk dengan stok di bawah minimum. Total ${totalLowStockItems} item perlu ditambahkan.'
      );

      // You could store this information for display in UI
      // For example, you might want to add:
      // RxList<Map<String, dynamic>> lowStockItems = <Map<String, dynamic>>[].obs;
      // lowStockItems.value = lowStockProducts;

    } catch (e) {
      print('Error fetching low stock products: $e');
      Get.snackbar('Error', 'Gagal memuat produk stok rendah: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
