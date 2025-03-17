import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/report_controller.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller before using Get.find
    final ReportController controller = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bulanan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export to Excel',
            onPressed: () => controller.exportReportToExcel(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: controller.selectedMonth.value,
                        decoration: const InputDecoration(labelText: 'Bulan'),
                        items: List.generate(12, (index) => index + 1)
                            .map((month) => DropdownMenuItem(
                                  value: month,
                                  child: Text(DateTime(2023, month)
                                      .toString()
                                      .split(' ')[0]
                                      .split('-')[1]),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateMonthYear(
                                controller.selectedYear.value, value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: controller.selectedYear.value,
                        decoration: const InputDecoration(labelText: 'Tahun'),
                        items: List.generate(
                                10, (index) => DateTime.now().year - 5 + index)
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateMonthYear(
                                value, controller.selectedMonth.value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Laporan Bulanan',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Produk')),
                      DataColumn(label: Text('Stok Awal')),
                      DataColumn(label: Text('Stok Masuk')),
                      DataColumn(label: Text('Stok Keluar')),
                      DataColumn(label: Text('Stok Akhir')),
                    ],
                    rows: controller.monthlyReport
                        .map((report) => DataRow(cells: [
                              DataCell(Text(report['name'])),
                              DataCell(Text(report['initialStock'].toString())),
                              DataCell(Text(report['stockIn'].toString())),
                              DataCell(Text(report['stockOut'].toString())),
                              DataCell(Text(report['finalStock'].toString())),
                            ]))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Produk Terlaris',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...controller.topSellingProducts
                    .take(5)
                    .map((product) => ListTile(
                          title: Text(product['name']),
                          subtitle: Text('Terjual: ${product['totalSold']}'),
                        )),
                const SizedBox(height: 20),
                const Text('Produk Perputaran Lambat',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...controller.slowMovingProducts
                    .take(5)
                    .map((product) => ListTile(
                          title: Text(product['name']),
                          subtitle: Text('Terjual: ${product['totalSold']}'),
                        )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
