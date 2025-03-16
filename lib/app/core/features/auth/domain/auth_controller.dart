import 'package:get/get.dart';
import '../data/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _authRepository.signIn(email, password);
      Get.offAllNamed('/dashboard');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    isLoading.value = true;
    try {
      await _authRepository.signUp(email, password);
      Get.snackbar('Sukses', 'Pendaftaran berhasil, silakan login');
      Get.toNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    Get.offAllNamed('/login');
  }
}
