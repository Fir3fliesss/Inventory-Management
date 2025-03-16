import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('user_id', _supabase.auth.currentUser!.id);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final response = await _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('id', productId)
          .eq('user_id', _supabase.auth.currentUser!.id)
          .single();
      return response;
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await _supabase.from('products').insert({
        ...productData,
        'user_id': _supabase.auth.currentUser!.id,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('products')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', productId)
          .eq('user_id', _supabase.auth.currentUser!.id);
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _supabase
          .from('products')
          .delete()
          .eq('id', productId)
          .eq('user_id', _supabase.auth.currentUser!.id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .lte('stock', 'min_stock');
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil produk stok rendah: $e');
    }
  }
}
