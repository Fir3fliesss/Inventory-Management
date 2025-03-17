import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/dashboard_controller.dart';
import '../../../../../routes/app_pages.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    // Check for low stock products and show snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.lowStockCount.value > 0) {
        Get.snackbar(
          icon: const Icon(Icons.warning, color: Colors.white),
          'Peringatan Stok Rendah',
          'Ada ${controller.lowStockCount.value} produk dengan stok rendah. Lakukan isi ulang!',
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    });

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
        final now = DateTime.now();
        final formattedDate = DateFormat('EEEE, MMMM d, y').format(now); // Format date
        final formattedTime = DateFormat('hh:mm:ss a').format(now); // Format time

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanggal: $formattedDate'),
              Text('Waktu: $formattedTime'),
              const SizedBox(height: 20),
              const Text('Selamat Datang Gheral Ganteng!',
                  style: TextStyle(fontSize: 24)),
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
                  onTap: () => Get.toNamed(AppRoutes.lowStock), // Navigate to LowStockPage
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
                leading: const Icon(Icons.category),
                title: const Text('Manajemen Kategori'),
                onTap: () => Get.toNamed(AppRoutes.categoryList),
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: const Text('Daftar Transaksi'),
                onTap: () => Get.toNamed(
                    AppRoutes.transactionList),
              ),
              // ListTile(
              //   leading: const Icon(Icons.qr_code),
              //   title: const Text('Scan Barcode'),
              //   onTap: () {},
              // ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Laporan'),
                onTap: () => Get.toNamed(AppRoutes.report),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
