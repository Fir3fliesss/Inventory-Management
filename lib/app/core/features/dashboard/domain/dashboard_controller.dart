import 'package:get/get.dart';
import '../data/dashboard_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = DashboardRepository();

  RxInt productCount = 0.obs;
  RxInt lowStockCount = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndSyncUser();
    fetchDashboardData();
  }

  // Remove onReady and didPopNext methods

  Future<void> _checkAndSyncUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final existingUser = await Supabase.instance.client
            .from('users')
            .select('id')
            .eq('id', user.id)
            .maybeSingle();

        if (existingUser == null) {
          await Supabase.instance.client.from('users').insert({
            'id': user.id,
            'email': user.email,
            'created_at': DateTime.now().toIso8601String(),
          });
        }
      } catch (e) {
        print('Error saat memeriksa user: $e');
      }
    }
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

  // Method to refresh dashboard from other controllers
  void refreshDashboard() {
    fetchDashboardData();
  }
}
