import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/dashboard_controller.dart';
import '../../../../../routes/app_pages.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Get.offAllNamed(AppRoutes.login), // Logout sederhana
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selamat Datang Gheral Ganteng!', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: const Text('Total Produk'),
                  subtitle: Text('${controller.productCount.value}'),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Stok Rendah'),
                  subtitle: Text('${controller.lowStockCount.value}'),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Menu Utama', style: TextStyle(fontSize: 18)),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Manajemen Produk'),
                onTap: () => Get.toNamed(AppRoutes.productList),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('Scan Barcode'),
                onTap: () {}, // Nanti dihubungkan ke halaman scanner
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Laporan'),
                onTap: () {}, // Nanti dihubungkan ke halaman laporan
              ),
            ],
          ),
        );
      }),
    );
  }
}
