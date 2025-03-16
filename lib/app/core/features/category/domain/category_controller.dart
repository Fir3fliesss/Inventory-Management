import 'package:get/get.dart';
import '../data/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository = CategoryRepository();

  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final fetchedCategories = await _repository.getAllCategories();
      print('Kategori yang diambil: $fetchedCategories'); // Debug log
      categories.value = fetchedCategories;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(String name, String? description) async {
    isLoading.value = true;
    try {
      await _repository.addCategory({
        'name': name,
        'description': description,
      });
      fetchCategories(); // Refresh daftar kategori
      Get.back();
      Get.snackbar('Sukses', 'Kategori berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
