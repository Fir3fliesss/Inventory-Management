import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  // Search query
  RxString searchQuery = ''.obs;

  // Filter states
  RxString selectedCategory = ''.obs;
  RxBool showLowStockOnly = false.obs;
  RxString sortBy = 'name'.obs; // Default sort by name
  RxBool sortAscending = true.obs;

  // Date range for filtering (if needed)
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Function to reset all filters
  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = '';
    showLowStockOnly.value = false;
    sortBy.value = 'name';
    sortAscending.value = true;
    startDate.value = null;
    endDate.value = null;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Update category filter
  void updateCategory(String categoryId) {
    selectedCategory.value = categoryId;
  }

  // Toggle low stock filter
  void toggleLowStockFilter(bool value) {
    showLowStockOnly.value = value;
  }

  // Update sort options
  void updateSortOptions(String field, bool ascending) {
    sortBy.value = field;
    sortAscending.value = ascending;
  }

  // Update date range
  void updateDateRange(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
  }
}
