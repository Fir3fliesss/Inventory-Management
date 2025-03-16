import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<int> getProductCount() async {
    final response = await _supabase
        .from('products')
        .select('id')
        .eq('user_id', _supabase.auth.currentUser!.id);
    return response.length;
  }

  Future<int> getLowStockCount() async {
    final data = await _supabase
        .from('products')
        .select('id')
        .eq('user_id', _supabase.auth.currentUser!.id)
        .filter('stock', 'lte', 'min_stock');

    return data.length;
  }
}
