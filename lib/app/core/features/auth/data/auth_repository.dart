import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Pastikan metode _syncUserToDatabase sudah dideklarasikan dengan benar
  Future<void> _syncUserToDatabase(User? authUser) async {
    if (authUser == null) return;

    try {
      // Periksa apakah user sudah ada di tabel users
      final existingUser = await _supabase
          .from('users')
          .select('id')
          .eq('id', authUser.id)
          .maybeSingle();

    // Jika belum ada, tambahkan ke tabel users
    if (existingUser == null) {
      await _supabase.from('users').insert({
        'id': authUser.id,
        'email': authUser.email,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('User berhasil ditambahkan ke tabel users');
    }
  } catch (e) {
    print('Error saat sinkronisasi user ke database: $e');
    // Tidak throw exception agar tidak mengganggu proses login
  }
}

  Future<void> signIn(String email, String password) async {
    try {
      print('Mencoba login dengan email: $email');
      await _supabase.auth.signInWithPassword(email: email, password: password);
      print('Login berhasil');
    } catch (e) {
      print('Error detail login: $e');
      throw Exception('Gagal login : $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(email: email, password: password);

      // Sinkronkan user baru ke tabel users
      await _syncUserToDatabase(response.user);
    } catch (e) {
      throw Exception('Gagal mendaftar: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Gagal logout: $e');
    }
  }

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
