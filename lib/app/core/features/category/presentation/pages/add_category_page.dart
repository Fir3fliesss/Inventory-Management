import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/category_controller.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController controller = Get.find<CategoryController>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kategori')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Kategori'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 20),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      controller.addCategory(
                        nameController.text,
                        descriptionController.text,
                      );
                    },
                    child: const Text('Simpan'),
                  )),
          ],
        ),
      ),
    );
  }
}
