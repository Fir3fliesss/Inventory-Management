import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/category_controller.dart';
import 'add_category_page.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kategori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddCategoryPage()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text('Tidak ada kategori'));
        }
        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return ListTile(
              title: Text(category['name']),
              subtitle: Text(category['description'] ?? 'Tidak ada deskripsi'),
            );
          },
        );
      }),
    );
  }
}
