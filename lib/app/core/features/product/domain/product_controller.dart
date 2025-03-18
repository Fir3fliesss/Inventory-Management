// import 'package:get/get.rx.dart';
import 'package:get/get.dart';
import '../data/product_repository.dart';

// Add this import
import '../../search_filter/domain/search_filter_controller.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  // Add search filter controller
  final SearchFilterController searchFilter = Get.put(SearchFilterController());

  RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  // Add this if it's not already there
  RxList<Map<String, dynamic>> filteredProducts = <Map<String, dynamic>>[].obs;

  void applyFilters() {
    var result = List<Map<String, dynamic>>.from(products);

    // Apply search query filter
    if (searchFilter.searchQuery.value.isNotEmpty) {
      final query = searchFilter.searchQuery.value.toLowerCase();
      result = result.where((product) =>
          product['name'].toString().toLowerCase().contains(query) ||
          (product['barcode']?.toString().toLowerCase() ?? '').contains(query)
      ).toList();
    }

    // Apply category filter - improved to handle different category field structures
    if (searchFilter.selectedCategory.value.isNotEmpty &&
        searchFilter.selectedCategory.value != 'all') {
      result = result.where((product) {
        // Check different possible category field names
        final productCategoryId = product['category_id']?.toString() ??
                                 product['categoryId']?.toString() ??
                                 '';

        return productCategoryId == searchFilter.selectedCategory.value;
      }).toList();
    }

    // Apply low stock filter
    if (searchFilter.showLowStockOnly.value) {
      result = result.where((product) =>
          (product['stock'] ?? 0) <= (product['min_stock'] ?? 0)
      ).toList();
    }

    // Apply sorting
    result.sort((a, b) {
      final field = searchFilter.sortBy.value;
      final ascending = searchFilter.sortAscending.value;

      dynamic valueA = a[field];
      dynamic valueB = b[field];

      // Handle null values
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return ascending ? -1 : 1;
      if (valueB == null) return ascending ? 1 : -1;

      // Compare based on type
      int comparison;
      if (valueA is num && valueB is num) {
        comparison = valueA.compareTo(valueB);
      } else {
        comparison = valueA.toString().compareTo(valueB.toString());
      }

      return ascending ? comparison : -comparison;
    });

    filteredProducts.value = result;
  }
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // Listen to changes in search filter
    ever(searchFilter.searchQuery, (_) => applyFilters());
    ever(searchFilter.selectedCategory, (_) => applyFilters());
    ever(searchFilter.showLowStockOnly, (_) => applyFilters());
    ever(searchFilter.sortBy, (_) => applyFilters());
    ever(searchFilter.sortAscending, (_) => applyFilters());
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      products.value = await _repository.getAllProducts();
      applyFilters();
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

      await _repository.addProduct(sanitizedData);
      fetchProducts(); // Refresh daftar produk
      Get.offNamed('/products'); // Navigate back to product list with back button
      Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah produk: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    isLoading.value = true;
    try {
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

      await _repository.updateProduct(productId, sanitizedUpdates);
      fetchProducts(); // Refresh daftar produk
      Get.offNamed('/products'); // Navigate back to product list with back button
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

  // Improved method to extract categories from products
  List<Map<String, dynamic>> getUniqueCategories() {
    final uniqueCategories = <Map<String, dynamic>>[];
    final categoryIds = <String>{};
    final categoryNames = <String>{};  // Track unique names too

    // Debug: Print the first product to see its structure
    if (products.isNotEmpty) {
      print('First product structure: ${products.first}');
    }

    for (var product in products) {
      // Try to get category ID from different possible field names
      final categoryId = product['category_id']?.toString() ??
                         product['categoryId']?.toString() ?? '';

      // Try to get category name from different possible field names
      String categoryName = '';
      if (product['category_name'] != null) {
        categoryName = product['category_name'].toString();
      } else if (product['categoryName'] != null) {
        categoryName = product['categoryName'].toString();
      } else if (product['category'] != null) {
        categoryName = product['category'].toString();
      } else {
        // If no category name is found, use a more descriptive fallback
        categoryName = 'Kategori ${categoryId.substring(0, categoryId.length > 5 ? 5 : categoryId.length)}';
      }

      // Ensure both ID and name are unique
      if (categoryId.isNotEmpty && !categoryIds.contains(categoryId)) {
        categoryIds.add(categoryId);

        // Ensure category name is unique by appending a number if needed
        String uniqueName = categoryName;
        int counter = 1;
        while (categoryNames.contains(uniqueName)) {
          uniqueName = '$categoryName ($counter)';
          counter++;
        }
        categoryNames.add(uniqueName);

        uniqueCategories.add({
          'id': categoryId,
          'name': uniqueName,
        });

        // Debug: Print each extracted category
        print('Extracted category: ID=$categoryId, Name=$uniqueName');
      }
    }

    return uniqueCategories;
  }
  // Add this method to get category name by ID
  String getCategoryName(String categoryId) {
    if (categoryId.isEmpty) return 'Tidak ada kategori';

    // Find the category in the unique categories
    final categories = getUniqueCategories();
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Kategori tidak ditemukan'},
    );

    return category['name']?.toString() ?? 'Kategori tidak ditemukan';
  }
}
