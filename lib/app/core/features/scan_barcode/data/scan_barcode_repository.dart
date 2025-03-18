import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanBarcodeRepository {
  Future<String?> scanBarcode() async {
    try {
      // Minta izin kamera
      var status = await Permission.camera.request();
      if (status.isGranted) {
        // Use the correct method from barcode_scan2
        var result = await BarcodeScanner.scan();

        // Check if scan was canceled
        if (result.type == ResultType.Cancelled) {
          return null;
        }

        return result.rawContent;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // Handle denied permissions
        throw Exception('Izin kamera ditolak. Silakan aktifkan di pengaturan perangkat.');
      } else {
        throw Exception('Izin kamera ditolak');
      }
    } catch (e) {
      throw Exception('Gagal memindai barcode: $e');
    }
  }
}
