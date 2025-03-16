import 'package:get/get.dart';
import '../data/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  RxInt productCount = 0.obs;
  RxInt lowStockCount = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      productCount.value = await _repository.getProductCount();
      lowStockCount.value = await _repository.getLowStockCount();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
