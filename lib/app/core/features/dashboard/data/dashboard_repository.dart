import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/product/data/product_repository.dart';

class DashboardRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ProductRepository _productRepository = ProductRepository();

  Future<int> getProductCount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final response = await _supabase
          .from('products')
          .select('id')
          .eq('user_id', user.id);

      return (response as List).length;
    } catch (e) {
      throw Exception('Gagal mengambil jumlah produk: $e');
    }
  }

  Future<int> getLowStockCount() async {
    try {
      // Menggunakan metode dari ProductRepository
      return await _productRepository.getLowStockCount();
    } catch (e) {
      throw Exception('Gagal mengambil jumlah stok rendah: $e');
    }
  }
}
