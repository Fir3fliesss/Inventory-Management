import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      final response = await _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('user_id', user.id);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      final response = await _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('id', productId)
          .eq('user_id', user.id)
          .single();
      return response;
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      // Pastikan cost tidak null
      if (!productData.containsKey('cost') || productData['cost'] == null) {
        // Gunakan price sebagai default jika tersedia, atau 0
        productData['cost'] = productData['price'] ?? 0.0;
      }

      print('Data yang diterima oleh repository: $productData'); // Debug log
      await _supabase.from('products').insert({
        ...productData,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error detail saat menambah produk: $e');
      throw Exception('Gagal menambah produk: $e');
    }
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updates) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      await _supabase
          .from('products')
          .update({
            ...updates,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', productId)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }
      await _supabase
          .from('products')
          .delete()
          .eq('id', productId)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      // Get all products for the user
      final response = await _supabase
          .from('products')
          .select('*, categories(name)')
          .eq('user_id', user.id);

      // Convert response to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> allProducts =
          (response as List).map((item) => item as Map<String, dynamic>).toList();

      // Filter products where stock <= min_stock
      final List<Map<String, dynamic>> lowStockProducts = allProducts.where((product) {
        final int stock = product['stock'] ?? 0;
        final int minStock = product['min_stock'] ?? 0;
        return stock <= minStock;
      }).toList();

      return lowStockProducts;
    } catch (e) {
      print('Error in getLowStockProducts: $e');
      throw Exception('Failed to fetch low stock products: $e');
    }
  }

  Future<int> getLowStockCount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak terautentikasi');
      }

      // Get all products for the user
      final response = await _supabase
          .from('products')
          .select('stock, min_stock')
          .eq('user_id', user.id);

      // Convert response to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> allProducts =
          (response as List).map((item) => item as Map<String, dynamic>).toList();

      // Count products where stock < min_stock
      int lowStockCount = 0;
      for (var product in allProducts) {
        final int stock = product['stock'] ?? 0;
        final int minStock = product['min_stock'] ?? 0;
        if (stock < minStock) {
          lowStockCount++;
        }
      }

      return lowStockCount;
    } catch (e) {
      print('Error in getLowStockCount: $e');
      throw Exception('Failed to fetch low stock count: $e');
    }
  }
}
