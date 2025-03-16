import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Gagal login : $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
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
