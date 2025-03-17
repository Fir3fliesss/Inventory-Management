import 'package:get/get.dart';
import 'package:excel/excel.dart';
import '../../report/data/report_repository.dart';
import 'dart:io'; // Import for file operations
import 'package:path_provider/path_provider.dart'; // Import for path operations

class ReportController extends GetxController {
  final ReportRepository _reportRepository = ReportRepository();

  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;
  RxList<Map<String, dynamic>> monthlyReport = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> topSellingProducts =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> slowMovingProducts =
      <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReport();
  }

  Future<void> fetchReport() async {
    isLoading.value = true;
    try {
      await fetchMonthlyReport();
      await fetchTopSellingProducts();
      await fetchSlowMovingProducts();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat laporan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMonthlyReport() async {
    final transactions = await _reportRepository.getMonthlyTransactions(
        selectedYear.value, selectedMonth.value);
    final previousTransactions = await _reportRepository.getStockBeforeMonth(
        selectedYear.value, selectedMonth.value);

    Map<String, Map<String, dynamic>> productSummary = {};

    // Hitung stok awal
    for (var tx in previousTransactions) {
      final productId = tx['product_id'];
      productSummary.putIfAbsent(
          productId,
          () => {
                'name': tx['products']['name'],
                'stockIn': 0,
                'stockOut': 0,
                'initialStock': 0,
              });
      if (tx['type'] == 'in') {
        productSummary[productId]!['initialStock'] += tx['quantity'];
      } else {
        productSummary[productId]!['initialStock'] -= tx['quantity'];
      }
    }

    // Hitung stok masuk dan keluar dalam bulan
    for (var tx in transactions) {
      final productId = tx['product_id'];
      productSummary.putIfAbsent(
          productId,
          () => {
                'name': tx['products']['name'],
                'stockIn': 0,
                'stockOut': 0,
                'initialStock': 0,
              });
      if (tx['type'] == 'in') {
        productSummary[productId]!['stockIn'] += tx['quantity'];
      } else {
        productSummary[productId]!['stockOut'] += tx['quantity'];
      }
    }

    // Konversi ke list dan hitung stok akhir
    monthlyReport.value = productSummary.entries.map((entry) {
      final summary = entry.value;
      summary['finalStock'] =
          summary['initialStock'] + summary['stockIn'] - summary['stockOut'];
      summary['productId'] = entry.key;
      return summary;
    }).toList();
  }

  Future<void> fetchTopSellingProducts() async {
    final transactions = await _reportRepository.getTopSellingProducts(
        selectedYear.value, selectedMonth.value);
    Map<String, Map<String, dynamic>> productSales = {};

    for (var tx in transactions) {
      final productId = tx['product_id'];
      productSales.putIfAbsent(
          productId,
          () => {
                'name': tx['products']['name'],
                'totalSold': 0,
              });
      productSales[productId]!['totalSold'] += tx['quantity'];
    }

    topSellingProducts.value = productSales.entries
        .map((entry) => {'productId': entry.key, ...entry.value})
        .toList()
      ..sort((a, b) => b['totalSold'].compareTo(a['totalSold']));
  }

  Future<void> fetchSlowMovingProducts() async {
    final transactions = await _reportRepository.getTopSellingProducts(
        selectedYear.value, selectedMonth.value);
    final allProducts = await _reportRepository.getAllProducts();

    Map<String, Map<String, dynamic>> productSales = {};
    for (var product in allProducts) {
      productSales[product['id']] = {
        'name': product['name'],
        'totalSold': 0,
      };
    }

    for (var tx in transactions) {
      final productId = tx['product_id'];
      if (productSales.containsKey(productId)) {
        productSales[productId]!['totalSold'] += tx['quantity'];
      }
    }

    slowMovingProducts.value = productSales.entries
        .map((entry) => {'productId': entry.key, ...entry.value})
        .toList()
      ..sort((a, b) => a['totalSold'].compareTo(b['totalSold']));
  }

  void updateMonthYear(int year, int month) {
    selectedYear.value = year;
    selectedMonth.value = month;
    fetchReport();
  }

  Future<void> exportReportToExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Monthly Report'];

      // Append header row
      sheet.appendRow([
        TextCellValue('Product ID'),
        TextCellValue('Name'),
        TextCellValue('Total Sold'),
        TextCellValue('Initial Stock'),
        TextCellValue('Final Stock')
      ]);

      // Append data rows
      for (var report in monthlyReport) {
        sheet.appendRow([
          TextCellValue(report['productId'].toString()),
          TextCellValue(report['name'].toString()),
          TextCellValue(report['stockOut'].toString()),
          TextCellValue(report['initialStock'].toString()),
          TextCellValue(report['finalStock'].toString()),
        ]);
      }

      final fileBytes = excel.save();

      // Save the file to the device
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/monthly_report.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes!);

      print('Laporan berhasil diekspor ke Excel: $filePath');
      Get.snackbar('Sukses', 'Laporan berhasil diekspor ke Excel: $filePath');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengekspor laporan: $e');
    }
  }
}
