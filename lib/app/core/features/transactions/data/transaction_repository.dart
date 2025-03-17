import 'package:supabase_flutter/supabase_flutter.dart';
import '../../transactions/data/transaction_model.dart';

class TransactionRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil semua transaksi untuk pengguna yang sedang login
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      final response = await _supabase
          .from('transactions')
          .select('*, products(name)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil transaksi: $e');
    }
  }

  // Menambah transaksi baru
  Future<void> addTransaction(Map<String, dynamic> transactionData) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      // Periksa apakah user ada di tabel users
      final userExists = await _supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      // Jika user tidak ada, tambahkan ke tabel users terlebih dahulu
      if (userExists == null) {
        await _supabase.from('users').insert({
          'id': user.id,
          'email': user.email,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // Sekarang tambahkan transaksi
      await _supabase.from('transactions').insert({
        ...transactionData,
        'user_id': user.id,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error detail saat menambah transaksi: $e'); // Tambahkan log detail
      throw Exception('Gagal menambah transaksi: $e');
    }
  }

  // Menghapus transaksi berdasarkan ID
  Future<void> deleteTransaction(String transactionId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Pengguna tidak terautentikasi');

      await _supabase
          .from('transactions')
          .delete()
          .eq('id', transactionId)
          .eq('user_id', user.id);
    } catch (e) {
      throw Exception('Gagal menghapus transaksi: $e');
    }
  }
}
