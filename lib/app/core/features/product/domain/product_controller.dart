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
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    isLoading.value = true;
    try {
      await _repository.addProduct(productData);
      fetchProducts(); // Refresh daftar produk
      Get.back(); // Kembali ke daftar produk
      Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    isLoading.value = true;
    try {
      await _repository.updateProduct(productId, updates);
      fetchProducts(); // Refresh daftar produk
      Get.back(); // Kembali ke daftar produk
      Get.snackbar('Sukses', 'Produk berhasil diperbarui');
    } catch (e) {
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
      Get.snackbar('Sukses', 'Produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    return await _repository.getProductById(productId);
  }
}
