import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/search_filter_controller.dart';

class FilterDialog extends StatelessWidget {
  final SearchFilterController controller;
  final List<Map<String, dynamic>> categories;
  final Function() onApply;

  const FilterDialog({
    Key? key,
    required this.controller,
    required this.categories,
    required this.onApply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height to 80% of screen
          maxWidth: MediaQuery.of(context).size.width * 0.9,  // Limit width to 90% of screen
        ),
        child: SingleChildScrollView(  // Add scrolling capability
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Category filter
                const Text('Kategori:'),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  hint: const Text('Pilih Kategori'),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('Semua Kategori'),
                    ),
                    ...categories.map((category) => DropdownMenuItem(
                      value: category['id'],
                      child: Text(category['name'] ?? 'Kategori'),
                    )),
                  ],
                  onChanged: (value) {
                    print('Selected category: $value');
                    controller.updateCategory(value ?? 'all');
                  },
                  isExpanded: true, // Prevent overflow in dropdown
                )),

                const SizedBox(height: 16),

                // Low stock filter
                Obx(() => CheckboxListTile(
                  title: const Text('Tampilkan Stok Rendah Saja'),
                  value: controller.showLowStockOnly.value,
                  onChanged: (value) {
                    controller.toggleLowStockFilter(value ?? false);
                  },
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                )),

                const SizedBox(height: 16),

                // Sort options
                const Text('Urutkan Berdasarkan:'),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.sortBy.value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'name',
                      child: Text('Nama'),
                    ),
                    DropdownMenuItem(
                      value: 'stock',
                      child: Text('Stok'),
                    ),
                    DropdownMenuItem(
                      value: 'price',
                      child: Text('Harga'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateSortOptions(value, controller.sortAscending.value);
                    }
                  },
                  isExpanded: true, // Prevent overflow in dropdown
                )),

                const SizedBox(height: 8),

                // Sort direction
                Obx(() => Column(  // Changed from Wrap to Column
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: controller.sortAscending.value,
                          onChanged: (value) {
                            controller.updateSortOptions(controller.sortBy.value, true);
                          },
                        ),
                        const Text('Naik (A-Z)'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: controller.sortAscending.value,
                          onChanged: (value) {
                            controller.updateSortOptions(controller.sortBy.value, false);
                          },
                        ),
                        const Text('Turun (Z-A)'),
                      ],
                    ),
                  ],
                )),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.resetFilters();
                      },
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        onApply();
                        Get.back();
                      },
                      child: const Text('Terapkan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
