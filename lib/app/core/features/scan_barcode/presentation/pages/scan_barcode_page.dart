import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/scan_barcode_controller.dart';

class ScanBarcodePage extends StatelessWidget {
  const ScanBarcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScanBarcodeController controller = Get.put(ScanBarcodeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: Center(
        child: Obx(() {
          if (controller.isScanning.value) {
            return const CircularProgressIndicator();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.startScan,
                child: const Text('Mulai Scan'),
              ),
              const SizedBox(height: 20),
              Text('Hasil: ${controller.scannedBarcode.value}'),
              if (controller.scannedBarcode.value.isNotEmpty)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Logika untuk lihat detail
                      },
                      child: const Text('Lihat Detail'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Logika untuk tambah stok
                      },
                      child: const Text('Tambah Stok'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Logika untuk kurangi stok
                      },
                      child: const Text('Kurangi Stok'),
                    ),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }
}
