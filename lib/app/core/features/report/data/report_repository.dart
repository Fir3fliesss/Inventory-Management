import 'package:supabase_flutter/supabase_flutter.dart';

class ReportRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Ambil data transaksi bulanan
  Future<List<Map<String, dynamic>>> getMonthlyTransactions(
      int year, int month) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final startDate = DateTime(year, month, 1);
      final endDate =
          DateTime(year, month + 1, 1).subtract(Duration(seconds: 1));

      final response = await _supabase
          .from('transactions')
          .select('*, products(name)')
          .eq('user_id', user.id)
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at', ascending: true);

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil transaksi bulanan: $e');
    }
  }

  // Ambil stok awal sebelum bulan tertentu
  Future<List<Map<String, dynamic>>> getStockBeforeMonth(
      int year, int month) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final endDate = DateTime(year, month, 1);

      final response = await _supabase
          .from('transactions')
          .select('*, products(name)')
          .eq('user_id', user.id)
          .lt('created_at', endDate.toIso8601String());

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil stok awal: $e');
    }
  }

  // Ambil produk terlaris
  Future<List<Map<String, dynamic>>> getTopSellingProducts(
      int year, int month) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final startDate = DateTime(year, month, 1);
      final endDate =
          DateTime(year, month + 1, 1).subtract(Duration(seconds: 1));

      final response = await _supabase
          .from('transactions')
          .select('product_id, products(name), quantity')
          .eq('user_id', user.id)
          .eq('type', 'out')
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String());

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil produk terlaris: $e');
    }
  }

  // Ambil semua produk
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final response = await _supabase
          .from('products')
          .select('id, name')
          .eq('user_id', user.id);

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil semua produk: $e');
    }
  }
}
