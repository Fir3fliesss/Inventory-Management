import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      final response =
          await _supabase.from('categories').select().eq('user_id', user.id);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      await _supabase.from('categories').insert({
        ...categoryData,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal menambah kategori: $e');
    }
  }
}
