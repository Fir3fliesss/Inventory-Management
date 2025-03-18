import 'package:get/get.dart';
import 'package:inventory_management/app/routes/app_pages.dart';
import '../../scan_barcode/data/scan_barcode_repository.dart';
import '../../product/domain/product_controller.dart';

class ScanBarcodeController extends GetxController {
  final ScanBarcodeRepository _repository = ScanBarcodeRepository();
  // Initialize ProductController with Get.put if it doesn't exist
  final ProductController _productController = Get.put(ProductController());
  RxString scannedBarcode = ''.obs;
  RxBool isScanning = false.obs;

  Future<void> startScan() async {
    isScanning.value = true;
    try {
      final barcode = await _repository.scanBarcode();
      if (barcode != null) {
        scannedBarcode.value = barcode;
        checkProduct(barcode);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memindai: $e');
    } finally {
      isScanning.value = false;
    }
  }

  void checkProduct(String barcode) {
    final product = _productController.products.firstWhere(
      (p) => p['barcode'] == barcode,
      orElse: () => <String, dynamic>{},
    );
    if (product != null) {
      Get.snackbar('Produk Ditemukan', 'Nama: ${product['name']}');
      // Navigasi ke detail atau aksi lain
    } else {
      Get.snackbar('Produk Tidak Ditemukan', 'Tambah produk baru?');
      Get.toNamed(AppRoutes.addProduct, arguments: {'barcode': barcode});
    }
  }
}
